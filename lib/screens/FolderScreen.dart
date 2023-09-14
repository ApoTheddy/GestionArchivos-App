import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:gfilesapp/UtilWidgets.dart';
import 'package:gfilesapp/screens/FolderContentScreen.dart';
import 'package:gfilesapp/screens/HomeScreen.dart';

class FolderScreen extends HookWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = useState<List<String>>([]);
    final folderNameController =
        useState<TextEditingController>(TextEditingController());

    useEffect(() {
      getDirs(folders);
      return;
    }, []);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(0, 80),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    itemBuilder: (c) => [
                      PopupMenuItem(
                        onTap: () {
                          showModalBottomSheet(
                              shape: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              context: context,
                              builder: (_) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                            height: 50,
                                            child: TextFormField(
                                              controller:
                                                  folderNameController.value,
                                              decoration: InputDecoration(),
                                            )),
                                        CupertinoButton(
                                            onPressed: () {
                                              String valueCtrl =
                                                  folderNameController
                                                      .value.text
                                                      .trim();
                                              if (valueCtrl.isNotEmpty) {
                                                addFolder(folders, valueCtrl,
                                                    context);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Agregar"))
                                      ]),
                                );
                              });
                        },
                        height: 20,
                        value: 1,
                        child: const Text('Crear una carpeta'),
                      ),
                    ],
                    child: const Icon(Icons.more_horiz, color: Colors.black),
                  ),
                ],
              ),
            )),
        body: Column(children: [
          Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: folders.value.length,
                  itemBuilder: (_, i) {
                    return InkWell(
                        onTap: () {
                          Get.to(
                              transition: Transition.cupertino,
                              () => FolderContentScreen(
                                  foldername: folders.value[i]));
                        },
                        onLongPress: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              builder: (_) {
                                return SizedBox(
                                  height: 50,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            String folderName =
                                                folders.value[i];
                                            removeFolder(
                                                context, folders, folderName);
                                          },
                                          child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Borrar"),
                                                SizedBox(width: 10),
                                                Icon(Icons.delete),
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.folder,
                                size: 100, color: Colors.grey),
                            Text(folders.value[i])
                          ],
                        ));
                  }))
        ]),
      ),
    );
  }

  Future<void> getDirs(ValueNotifier<List<String>> folders) async {
    try {
      folders.value = await fileService.getDirs();
    } catch (err) {
      print("Error: $err");
    }
  }

  Future<void> removeFolder(BuildContext ctx,
      ValueNotifier<List<String>> folders, String folderName) async {
    int index = folders.value.indexOf(folderName);
    folders.value.removeAt(index);
    bool isDeleted = await fileService.removeDir(folderName);

    if (isDeleted) {
      folders.notifyListeners();
      Navigator.pop(ctx);
      showSnackbar(ctx, "Folder eliminado correctamente");
    } else {
      Navigator.pop(ctx);
      showSnackbar(ctx, "No se pudo eliminar el folder");
    }
  }

  Future<void> addFolder(ValueNotifier<List<String>> folders, String folderName,
      BuildContext ctx) async {
    bool isCreate = await fileService.createDir(folderName);
    if (isCreate) {
      folders.value.add(folderName);
      folders.notifyListeners();
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text("No se pudo crear la carpeta"),
          duration: Duration(seconds: 1)));
    }
  }
}
