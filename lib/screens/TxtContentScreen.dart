import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfilesapp/components/NavBar.dart';
import 'package:gfilesapp/models/FileModel.dart';

class TxtContentScreen extends HookWidget {
  const TxtContentScreen({super.key, required this.file});
  final FileModel file;

  @override
  Widget build(BuildContext context) {
    final contentText = useState<String>("");

    useEffect(() {
      getDataText(contentText);
      return;
    }, []);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 80),
        child: NavBar(title: file.filename),
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Hero(
                tag: file.id,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(contentText.value)))),
          ),
        ),
        InkWell(
            onTap: () {
              print("delete");
            },
            child: const SizedBox(
                height: 50, child: Center(child: Icon(Icons.delete)))),
      ]),
    );
  }

  Future<void> getDataText(ValueNotifier content) async {
    try {
      final uri = Uri.parse(file.filepath);
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        content.value = await utf8.decodeStream(response);
      } else {
        print("Error al obtener el archivo ${response.statusCode}");
      }
    } catch (err) {
      print("Error: $err");
    }
  }
}
