import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfilesapp/UtilWidgets.dart';
import 'package:gfilesapp/components/CardFile.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:gfilesapp/screens/HomeScreen.dart';

class PhotoScreen extends HookWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final files = useState<List<FileModel>>([]);

    useEffect(() {
      getFiles(files);
      return;
    }, []);

    return Scaffold(
      body: Column(
        children: [
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
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
                            pickCamera(context, files, "");
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
                            pickGallery(context, files, "");
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getFiles(ValueNotifier<List<FileModel>> files) async {
    try {
      files.value = await fileService.getOnlyPhotos();
    } catch (err) {
      print("Error: $err");
      return;
    }
  }
}
