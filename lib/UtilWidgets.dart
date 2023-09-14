import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:gfilesapp/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext ctx, String message) {
  ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
}

Future<void> pickGallery(BuildContext ctx, ValueNotifier<List<FileModel>> files,
    String? folderName) async {
  final picker = ImagePicker();
  final media = await picker.pickMultipleMedia();
  if (media.isNotEmpty) {
    final uploadFutures = media
        .map((XFile file) => fileService.uploadFile(file, folderName))
        .toList();

    try {
      final uploadedFiles = await Future.wait(uploadFutures);
      files.value.addAll(
          uploadedFiles.where((file) => file != null).cast<FileModel>());
      showSnackbar(ctx, "Archivos subido correctamente");
    } catch (err) {
      showSnackbar(ctx, "Hubo un error al subir algunos archivos");
    } finally {
      Navigator.pop(ctx);
      files.notifyListeners();
    }

    files.notifyListeners();
  } else {
    Navigator.pop(ctx);
    showSnackbar(ctx, "No se selecciono ningun archivo");
  }
}

Future<void> pickCamera(BuildContext ctx, ValueNotifier<List<FileModel>> files,
    String? folderName) async {
  final picker = ImagePicker();
  final img = await picker.pickImage(source: ImageSource.camera);

  if (img != null) {
    FileModel? newFile = await fileService.uploadFile(img, "");
    if (newFile != null) {
      files.value.add(newFile);
      files.notifyListeners();
      Navigator.pop(ctx);
      showSnackbar(ctx, "Archivo subido correctamente");
    } else {
      Navigator.pop(ctx);
      showSnackbar(ctx, "No se pudo subir el archivo");
    }
  } else {
    Navigator.pop(ctx);
    showSnackbar(ctx, "No se selecciono ningun archivo");
  }
}

Future<void> removeFile(
    BuildContext ctx, int id, ValueNotifier<List<FileModel>> files) async {
  int index = files.value.indexWhere((file) => file.id == id);
  files.value.removeAt(index);
  files.notifyListeners();
  await fileService.removeFileById(id);
}
