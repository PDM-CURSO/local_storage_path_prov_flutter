import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'files_event.dart';
part 'files_state.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesInitial()) {
    on<ReadFileEvent>(_readFileFromStorage);
    on<SaveFileEvent>(_saveFileIntoStorage);
  }

  FutureOr<void> _readFileFromStorage(ReadFileEvent event, emit) async {
    switch (event.storageName) {
      case "tempDirectory":
        var _tempDir = await getTemporaryDirectory();
        var _fileContent = await _readFile(event.fileTitle, _tempDir);
        emit(ReadFileSuccessState(fileContent: _fileContent));
        break;
      case "externalStorageDirectory":
        if (!await _requestStoragePermission()) {
          emit(ReadFileErrorState(
              error: "Se requiere permiso para leer del almacenamiento"));
        } else {
          var _extDir = await getExternalStorageDirectory();
          var _fileContent = await _readFile(event.fileTitle, _extDir!);

          emit(ReadFileSuccessState(fileContent: _fileContent));
        }
        break;
      default:
    }
  }

  FutureOr<void> _saveFileIntoStorage(SaveFileEvent event, emit) async {
    switch (event.storageName) {
      case "tempDirectory":
        var _tempDir = await getTemporaryDirectory();
        try {
          await _saveFile(event.fileTitle, event.fileContent, _tempDir);
          emit(SavedFileSuccessState());
        } catch (e) {
          emit(SavedFileErrorState(error: "No se ha podido guardar archivo"));
        }
        break;
      case "externalStorageDirectory":
        if (!await _requestStoragePermission()) {
          emit(ReadFileErrorState(
              error: "Se requiere permiso para leer del almacenamiento"));
        } else {
          var _extDir = await getExternalStorageDirectory();
          try {
            await _saveFile(event.fileTitle, event.fileContent, _extDir!);
            emit(SavedFileSuccessState());
          } catch (e) {
            emit(SavedFileErrorState(error: "No se ha podido guardar archivo"));
          }
        }
        break;
      default:
    }
  }

  Future<bool> _requestStoragePermission() async {
    var permiso = await Permission.storage.status;
    if (permiso == PermissionStatus.denied) {
      await Permission.storage.request();
    }
    return permiso == PermissionStatus.granted;
  }

  Future<void> _saveFile(String _title, String _content, Directory dir) async {
    if (!await _requestStoragePermission()) {
      throw Exception();
    }
    // crear y escribir archivo
    final File file = File("${dir.path}/$_title.txt");
    await file.writeAsString(_content);
  }

  Future<String> _readFile(String _title, Directory dir) async {
    String _content = "Not found";
    try {
      final File file = File("${dir.path}/$_title.txt");
      _content = await file.readAsString();
      return _content;
    } catch (e) {
      return _content;
    }
  }
}
