import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/resource_cubit/download_pdf_file/download_pdf_file_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/resource_cubit/get_resource/get_resource_cubit.dart';
import 'package:studybean/features/roadmap/views/roadmap/widgets/note_widget.dart';
import 'package:studybean/features/splash/error_page.dart';
import 'package:studybean/features/splash/loading_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/roadmap.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({
    super.key,
    required this.resourceId,
  });

  final String resourceId;

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  bool isFullScreen = false;

  Widget _buildResourcePage(BuildContext context, ActionResource resource) {
    switch (resource.resourceType) {
      case ResourceType.pdf:
        return ResourcePdfWidget(url: resource.url, resourceId: resource.id);
      case ResourceType.image:
        return ResourceImageWidget(url: resource.url);
      case ResourceType.websiteLink:
        return ResourceWebsiteWidget(url: resource.url);
      case ResourceType.youtubeLink:
        return ResourceYoutubeWidget(
          url: resource.url,
          onFullScreen: (value) {
            if (value == isFullScreen) return;
            setState(() {
              isFullScreen = value;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GetResourceCubit>()..getResource(widget.resourceId),
      child: BlocBuilder<GetResourceCubit, GetResourceState>(
        builder: (context, state) {
          switch (state) {
            case GetResourceInitial():
            case GetResourceLoading():
              return const LoadingPage();
            case GetResourceFailed():
              return const ErrorPage();
            case GetResourceSuccess():
              return Scaffold(
                appBar: isFullScreen
                    ? null
                    : AppBar(
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              final updatedActionResource = await context
                                  .showBottomSheet<ActionResource?>(
                                      heightRatio: 1,
                                      builder: (context) => NoteWidget(
                                          resourceId: widget.resourceId, notes: state.actionResource.notes,));

                              if (updatedActionResource != null &&
                                  context.mounted) {
                                context
                                    .read<GetResourceCubit>()
                                    .reloadResource(updatedActionResource);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit_note_rounded),
                            ),
                          ),
                        ],
                      ),
                body: _buildResourcePage(context, state.actionResource),
              );
          }
        },
      ),
    );
  }
}

class ResourcePdfWidget extends StatelessWidget {
  const ResourcePdfWidget(
      {super.key, required this.url, required this.resourceId});

  final String url;
  final String resourceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DownloadPdfFileCubit>()..getFile(url, resourceId),
      child: BlocBuilder<DownloadPdfFileCubit, DownloadPdfFileState>(
        builder: (context, state) {
          switch (state) {
            case DownloadPdfFileInitial():
            case DownloadPdfFileLoading():
              return const LoadingPage();
            case DownloadPdfFileLoaded():
              return PDFView(
                filePath: state.filePath,
              );
            case DownloadPdfFileFailed():
              return ErrorWidget(state.error);
          }
        },
      ),
    );
  }
}

class ResourceYoutubeWidget extends StatefulWidget {
  const ResourceYoutubeWidget(
      {super.key, required this.url, required this.onFullScreen});

  final String url;
  final Function(bool) onFullScreen;

  @override
  State<ResourceYoutubeWidget> createState() => _ResourceYoutubeWidgetState();
}

class _ResourceYoutubeWidgetState extends State<ResourceYoutubeWidget> {
  late final YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    final id = widget.url.split('/').last;
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
    super.initState();
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubePlayerController,
        showVideoProgressIndicator: true,
      ),
      onEnterFullScreen: () {
        widget.onFullScreen.call(true);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      },
      onExitFullScreen: () {
        widget.onFullScreen.call(false);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      },
      builder: (context, player) {
        return Column(
          children: [player],
        );
      },
    );
  }
}

class ResourceImageWidget extends StatelessWidget {
  const ResourceImageWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(url);
  }
}

class ResourceWebsiteWidget extends StatelessWidget {
  const ResourceWebsiteWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
    );
  }
}
