part of 'files_bloc.dart';

abstract class FilesState extends Equatable {
  const FilesState();

  @override
  List<Object> get props => [];
}

class FilesInitial extends FilesState {}

class LoadingState extends FilesState {}

class SavedFileSuccessState extends FilesState {}

class SavedFileErrorState extends FilesState {
  final String error;

  SavedFileErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class ReadFileErrorState extends FilesState {
  final String error;

  ReadFileErrorState({required this.error});
  @override
  List<Object> get props => [error];
}

class ReadFileSuccessState extends FilesState {
  final String fileContent;

  ReadFileSuccessState({required this.fileContent});
  @override
  List<Object> get props => [fileContent];
}
