import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studybean/features/roadmap/repositories/roadmap_repository.dart';

part 'download_pdf_file_state.dart';

class DownloadPdfFileCubit extends Cubit<DownloadPdfFileState> {
  DownloadPdfFileCubit(this._roadmapRepository) : super(DownloadPdfFileInitial());

  final RoadmapRepository _roadmapRepository;

  Future<void> getFile(String url, String resourceId) async {
    try {
      emit(DownloadPdfFileLoading());

      final resourceUrlFilePath = await _roadmapRepository.downloadFile(url, resourceId);

      emit(DownloadPdfFileLoaded(filePath: resourceUrlFilePath));
    } catch (e, stackTrace) {
      addError(e, stackTrace);
      emit(DownloadPdfFileFailed(e));
    }
  }
}