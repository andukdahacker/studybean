import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/choose_subject_cubit/choose_subject_cubit.dart';
import 'package:studybean/features/roadmap/views/create_roadmap/bloc/create_subject_cubit/create_subject_cubit.dart';

import '../../../../../common/di/get_it.dart';

class ChooseSubjectWidget extends StatefulWidget {
  const ChooseSubjectWidget({
    super.key,
    required this.onNext,
    required this.selectedSubjectName,
  });

  final Function(String) onNext;
  final String? selectedSubjectName;

  @override
  State<ChooseSubjectWidget> createState() => _ChooseSubjectWidgetState();
}

class _ChooseSubjectWidgetState extends State<ChooseSubjectWidget> {
  late final TextEditingController _textEditingController;
  final _focusNode = FocusNode();
  Timer? _debounce;

  bool canNext = false;

  @override
  void initState() {
    _textEditingController = TextEditingController()..text = widget.selectedSubjectName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ChooseSubjectCubit>()..getSubjects(''),
        ),
        BlocProvider(
          create: (context) => getIt<CreateSubjectCubit>(),
        ),
      ],
      child: BlocBuilder<ChooseSubjectCubit, ChooseSubjectState>(
        builder: (context, state) {
          return Stack(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a subject',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'I am trying to learn...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          context.read<ChooseSubjectCubit>().getSubjects('');
                          _debounce?.cancel();
                          setState(() {
                            canNext = false;
                          });
                          return;
                        }

                        if (_debounce?.isActive ?? false) {
                          _debounce?.cancel();
                        }

                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                          context.read<ChooseSubjectCubit>().getSubjects(value);
                        });

                        setState(() {
                          canNext = true;
                        });
                      },
                      decoration: const InputDecoration()
                          .applyDefaults(context.theme.inputDecorationTheme)
                          .copyWith(
                            hintText:
                                'Programming, Mathematics, Science, English,...',
                          ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<ChooseSubjectCubit, ChooseSubjectState>(
                      builder: (context, state) {
                        switch (state) {
                          case ChooseSubjectInitial():
                          case ChooseSubjectLoading():
                            return const Center(
                                child: CircularProgressIndicator());
                          case ChooseSubjectLoaded():
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.subjects
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          _textEditingController.text = e.name;
                                          setState(() {
                                            canNext = true;
                                          });
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Text(e.name)),
                                      ))
                                  .toList(),
                            );
                          case ChooseSubjectError():
                            return Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.error,
                                      color: Colors.amberAccent),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Something went wrong, please try again',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<ChooseSubjectCubit>()
                                          .getSubjects('');
                                    },
                                    child: const Text('Retry'),
                                  )
                                ],
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_textEditingController.text.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => widget.onNext.call(_textEditingController.text),
                    child: const Text(
                      'Next',
                    ),
                  ),
                ),
              )
          ]);
        },
      ),
    );
  }
}
