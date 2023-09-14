import 'package:flutter/material.dart';
import 'package:gfilesapp/UtilWidgets.dart';
import 'package:gfilesapp/components/NavBar.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:gfilesapp/screens/HomeScreen.dart';

class PhotoContentScreen extends StatelessWidget {
  const PhotoContentScreen(
      {super.key, required this.file, required this.files});
  final FileModel file;
  final ValueNotifier<List<FileModel>> files;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(0, 80),
              child: NavBar(title: file.filename)),
          body: Column(children: [
            Expanded(
              child: Center(
                child: Hero(
                    tag: file.id,
                    child: Image.network(file.filepath, fit: BoxFit.cover)),
              ),
            ),
            InkWell(
                onTap: () {
                  removeFile(context, file.id, files);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                    height: 50, child: Center(child: Icon(Icons.delete)))),
          ])),
    );
  }
}
