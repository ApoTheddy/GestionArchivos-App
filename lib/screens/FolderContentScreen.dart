import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:gfilesapp/UtilWidgets.dart';
import 'package:gfilesapp/components/CardFile.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:gfilesapp/screens/HomeScreen.dart';
import 'package:gfilesapp/screens/PhotoContentScreen.dart';

class FolderContentScreen extends HookWidget {
  const FolderContentScreen({super.key, required this.foldername});
  final String foldername;

  @override
  Widget build(BuildContext context) {
    final files = useState<List<FileModel>>([]);

    useEffect(() {
      getFilesByDirName(files);
      return;
    }, []);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(0, 80),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back)),
                  Text(foldername.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19))
                ]),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: files.value.length,
                  itemBuilder: (_, i) {
                    return CardFile(file: files.value[i], files: files);
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            focusColor: Colors.transparent,
            disabledElevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            splashColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            hoverColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  builder: (_) {
                    return SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                pickCamera(context, files, foldername);
                              },
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Camera"),
                                    SizedBox(width: 10),
                                    Icon(Icons.camera_alt),
                                  ]),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                pickGallery(context, files, foldername);
                              },
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Gallery"),
                                    SizedBox(width: 10),
                                    Icon(Icons.image),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            },
            mini: true,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            )),
      ),
    );
  }

  void getFilesByDirName(ValueNotifier<List<FileModel>> files) async {
    files.value = await fileService.getFilesByDirName(foldername);
  }
}
