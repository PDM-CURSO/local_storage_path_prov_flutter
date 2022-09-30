part of 'files_bloc.dart';

abstract class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object> get props => [];
}

class SaveFileEvent extends FilesEvent {
  final String fileTitle;
  final String fileContent;
  final String storageName;

  SaveFileEvent({
    required this.fileTitle,
    required this.fileContent,
    required this.storageName,
  });
  @override
  List<Object> get props => [fileContent, fileTitle, storageName];
}

class ReadFileEvent extends FilesEvent {
  final String fileTitle;
  final String storageName;

  ReadFileEvent({
    required this.fileTitle,
    required this.storageName,
  });
  @override
  List<Object> get props => [fileTitle, storageName];
}
