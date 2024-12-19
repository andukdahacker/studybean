import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:studybean/common/di/get_it.dart';
import 'package:studybean/features/roadmap/views/roadmap/bloc/resource_cubit/resource_cubit.dart';
import 'package:studybean/features/splash/loading_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/roadmap.dart';

class ResourcePage extends StatelessWidget {
  const ResourcePage({
    super.key,
    required this.url,
    required this.resourceId,
    required this.resourceType,
  });

  final String url;
  final String resourceId;
  final ResourceType resourceType;

  Widget _buildResourcePage(BuildContext context) {
    switch (resourceType) {
      case ResourceType.pdf:
        return ResourcePdfWidget(url: url, resourceId: resourceId);
      case ResourceType.image:
      case ResourceType.websiteLink:
      case ResourceType.youtubeLink:
        return ResourceYoutubeWidget(url: url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildResourcePage(context),
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
      create: (context) => getIt<ResourceCubit>()..getFile(url, resourceId),
      child: BlocBuilder<ResourceCubit, ResourceState>(
        builder: (context, state) {
          switch (state) {
            case ResourceInitial():
            case ResourceLoading():
              return const LoadingPage();
            case ResourceLoaded():
              return PDFView(
                filePath: state.filePath,
              );
            case ResourceFailed():
              return ErrorWidget(state.error);
          }
        },
      ),
    );
  }
}

class ResourceYoutubeWidget extends StatefulWidget {
  const ResourceYoutubeWidget({super.key, required this.url});

  final String url;

  @override
  State<ResourceYoutubeWidget> createState() => _ResourceYoutubeWidgetState();
}

class _ResourceYoutubeWidgetState extends State<ResourceYoutubeWidget> {
  late final YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    final id = widget.url.split('/').last;
    _youtubePlayerController = YoutubePlayerController(
        initialVideoId: id, flags: YoutubePlayerFlags(autoPlay: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _youtubePlayerController,
      showVideoProgressIndicator: true,
    );
  }
}
