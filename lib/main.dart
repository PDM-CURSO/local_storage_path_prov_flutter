import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_storage_example/home/home_page.dart';

import 'home/bloc/files_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: BlocProvider(
        create: (context) => FilesBloc(),
        child: HomePage(),
      ),
    );
  }
}
