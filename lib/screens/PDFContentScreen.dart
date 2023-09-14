import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gfilesapp/components/NavBar.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import "package:http/http.dart" as http;

class PDFContentScreen extends StatefulWidget {
  const PDFContentScreen({super.key, required this.file});
  final FileModel file;

  @override
  State<PDFContentScreen> createState() => _PDFContentScreenState();
}

class _PDFContentScreenState extends State<PDFContentScreen> {
  String? localFilePath;

  Future<void> downloadPDF() async {
    final response = await http
        .get(Uri.parse("http://192.168.1.7:3000/files/${widget.file.id}"));

    if (response.statusCode == 200) {
      final documentDirectory = await getApplicationDocumentsDirectory();
      final localPath = documentDirectory.path;
      final filepath = "$localPath/${widget.file.filename}";
      File file = File(filepath);
      await file.writeAsBytes(response.bodyBytes);
      if (mounted) {
        setState(() {
          localFilePath = filepath;
        });
      }
    }
  }

  @override
  void initState() {
    downloadPDF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(0, 80),
              child: NavBar(title: widget.file.filename)),
          body: Column(children: [
            Expanded(
              child: Center(
                  child: localFilePath != null
                      ? PDFView(
                          filePath: localFilePath!,
                          // Opcional: Configura otras propiedades del visor según tus necesidades
                          // Ejemplo: zoom, scrollHorizontal, etc.
                        )
                      : CircularProgressIndicator()),
            ),
            InkWell(
                onTap: () {
                  print("delete");
                },
                child: const SizedBox(
                    height: 50,
                    child: const Center(child: Icon(Icons.delete)))),
          ])),
    );
  }
}
