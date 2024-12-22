import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/widgets/bottom_sheet_header_widget.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/note_cubit/parse_note/parse_note_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/note_cubit/save_note/save_note_cubit.dart';
import 'package:studybean/features/splash/error_page.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({
    super.key,
    required this.resourceId,
    this.notes,
  });

  final String? notes;
  final String resourceId;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  final QuillController _quillController = QuillController.basic();
  Timer? debounceTimer;

  void onDocumentChange(BuildContext context) {
    if (debounceTimer?.isActive ?? false) {
      debounceTimer?.cancel();
    }

    debounceTimer = Timer(const Duration(seconds: 1), () {
      final json = jsonEncode(_quillController.document.toDelta().toJson());
      final saveNoteCubit =
      BlocProvider.of<SaveNoteCubit>(context, listen: false);
      saveNoteCubit.saveNote(widget.resourceId, json);
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          getIt<ParseNoteCubit>()
            ..parseNote(widget.notes),
        ),
        BlocProvider(
          create: (context) => getIt<SaveNoteCubit>(),
        ),
      ],
      child: Column(
        children: [
          BlocConsumer<SaveNoteCubit, SaveNoteState>(
            listener: (context, state) {
              switch(state) {
                case SaveNoteInitial():
                  break;
                case SaveNoteLoading():
                  break;
                case SaveNoteSuccess():
                  break;
                case SaveNoteFailed():
                  break;
              }
            },
            builder: (context, state) {
              Widget saveNoteStatusWidget = const SizedBox.shrink();
              ActionResource? actionResource;
              switch(state) {
                case SaveNoteInitial():
                  break;
                case SaveNoteLoading():
                  saveNoteStatusWidget = const Text('Syncing note...');
                  break;
                case SaveNoteSuccess():
                  saveNoteStatusWidget = const Text('Note is synced.');
                  actionResource = state.actionResource;
                  break;
                case SaveNoteFailed():
                  saveNoteStatusWidget = const Text('Failed to sync notes');
                  break;
              }
              return BottomSheetHeaderWidget(
                action: saveNoteStatusWidget,
                onClose: () {
                  context.pop(actionResource);
                },
              );
            },
          ),
          QuillSimpleToolbar(
            configurations:
            const QuillSimpleToolbarConfigurations(multiRowsDisplay: false),
            controller: _quillController,
          ),
          BlocConsumer<ParseNoteCubit, ParseNoteState>(
            listener: (context, state) {
              switch (state) {
                case ParseNoteInitial():
                  break;
                case ParseNoteLoading():
                  break;
                case ParseNoteFailed():
                  break;
                case ParseNoteSuccess():
                  if (state.json == null) break;
                  _quillController.document = Document.fromJson(state.json);
                  break;
              }
            },
            builder: (context, state) {
              switch (state) {
                case ParseNoteInitial():
                case ParseNoteLoading():
                  return const Center(child: CircularProgressIndicator());
                case ParseNoteSuccess():
                  _quillController.addListener(() {
                    onDocumentChange(context);
                  });
                  return Expanded(
                    child: QuillEditor.basic(
                      controller: _quillController,
                      configurations: const QuillEditorConfigurations(),
                    ),
                  );
                case ParseNoteFailed():
                  return const ErrorPage();
              }
            },
          )
        ],
      ),
    );
  }
}
