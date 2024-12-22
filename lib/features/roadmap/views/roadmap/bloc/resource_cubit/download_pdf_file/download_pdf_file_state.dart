part of 'download_pdf_file_cubit.dart';

sealed class DownloadPdfFileState extends Equatable {}

class DownloadPdfFileInitial extends DownloadPdfFileState {
  @override
  List<Object?> get props => [];
}

class DownloadPdfFileLoading extends DownloadPdfFileState {
  @override
  List<Object?> get props => [];
}

class DownloadPdfFileLoaded extends DownloadPdfFileState {
  final String filePath;

  DownloadPdfFileLoaded({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class DownloadPdfFileFailed extends DownloadPdfFileState {
  final Object error;

  DownloadPdfFileFailed(this.error);
  @override
  List<Object?> get props => [error];

}

