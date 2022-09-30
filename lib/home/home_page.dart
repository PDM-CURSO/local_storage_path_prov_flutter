import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_storage_example/home/bloc/files_bloc.dart';

class HomePage extends StatelessWidget {
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: BlocConsumer<FilesBloc, FilesState>(
        listener: (context, state) {
          if (state is SavedFileSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Se ha guardado correctamente..")),
            );
            _contentC.clear();
          } else if (state is SavedFileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al guardar  ${state.error}..")),
            );
            _titleC.clear();
          } else if (state is ReadFileSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Cargando contenido..")),
            );
            _contentC.text = state.fileContent;
          } else if (state is ReadFileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Error al leer archivo: ${state.error}..")),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingState)
            return _loadingView();
          else if (state is ReadFileSuccessState)
            return _defaultView(context, state.fileContent);
          else
            return _defaultView(context, null);
        },
      ),
    );
  }

  Widget _loadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _defaultView(BuildContext context, String? contentRead) {
    if (contentRead != null) _contentC.text = contentRead;
    return ListView(
      children: [
        _itemSaveOrRead(
          context,
          "tempDirectory",
          "/data/user/0/com.app.package/cache",
        ),
        Divider(),
        _itemSaveOrRead(
          context,
          "externalStorageDirectory",
          "/storage/emulated/0/Android/data/com.app.package/files",
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _titleC,
            decoration: InputDecoration(
              label: Text("Titulo del archivo"),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _contentC,
            maxLines: 2,
            maxLength: 100,
            decoration: InputDecoration(
              label: Text("Contenido del archivo"),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemSaveOrRead(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: IconButton(
        tooltip: "Guardar archivo",
        onPressed: () {
          BlocProvider.of<FilesBloc>(context).add(
            SaveFileEvent(
              fileTitle: _titleC.text,
              fileContent: _contentC.text,
              storageName: title,
            ),
          );
        },
        icon: Icon(FontAwesomeIcons.fileSignature),
      ),
      trailing: IconButton(
        tooltip: "Leer archivo",
        onPressed: () {
          BlocProvider.of<FilesBloc>(context).add(
            ReadFileEvent(
              fileTitle: _titleC.text,
              storageName: title,
            ),
          );
        },
        icon: Icon(FontAwesomeIcons.readme),
      ),
    );
  }
}
