import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gfilesapp/models/FileModel.dart';
import 'package:gfilesapp/screens/PDFContentScreen.dart';
import 'package:gfilesapp/screens/PhotoContentScreen.dart';
import 'package:gfilesapp/screens/TxtContentScreen.dart';
import 'package:gfilesapp/screens/VideoContentScreen.dart';
import "package:path/path.dart";
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

bool isPermissionGranted = false;

class CardFile extends StatelessWidget {
  const CardFile({super.key, required this.file, required this.files});
  final FileModel file;
  final ValueNotifier<List<FileModel>> files;

  @override
  Widget build(BuildContext context) {
    return verifyTypeExtension(context);
  }

  Widget verifyTypeExtension(BuildContext ctx) {
    Map<String, Widget> type = {
      ".jpg": _buildImgType(ctx),
      ".png": _buildImgType(ctx),
      ".jpeg": _buildImgType(ctx),
      ".mp4": _buildVideoType(ctx),
      ".mkv": _buildVideoType(ctx),
      ".txt": _buildTxtType(),
      ".pdf": _buildPdfType(),
    };

    return type[file.ext] ?? _buildOtherType();
  }

  Widget _buildImgType(BuildContext ctx) {
    return InkWell(
      onTap: () {
        Get.to(() => PhotoContentScreen(file: file, files: files),
            transition: Transition.cupertino);
      },
      child: Hero(
        tag: file.id,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(file.filepath), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget _buildVideoType(BuildContext ctx) {
    return InkWell(
      onTap: () {
        Get.to(() => VideoContentScreen(file: file, files: files),
            transition: Transition.cupertino);
      },
      child: FutureBuilder(
        future: getVideoThumbnail(file.filepath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ocurrió un error con la imagen"));
          }

          if (snapshot.data != null) {
            return Image.file(File(snapshot.data!), fit: BoxFit.cover);
          } else {
            return const SizedBox(
                child: Center(
                    child: Text("Sin imagen"))); // No se encontró una miniatura
          }
        },
      ),
    );
  }

  Future<String?> getVideoThumbnail(String videoPath) async {
    var status = await Permission.storage.request();
    String? fileName;
    if (status.isGranted) {
      try {
        fileName = await VideoThumbnail.thumbnailFile(
          video: videoPath,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
        );
      } catch (err) {
        print("Ocurrió un error: $err");
      }
    }
    return fileName;
  }

  Widget _buildTxtType() {
    return InkWell(
      onTap: () {
        Get.to(() => TxtContentScreen(file: file),
            transition: Transition.cupertino);
      },
      child: SvgPicture.asset("assets/document-icon.svg"),
    );
  }

  Widget _buildPdfType() {
    return InkWell(
      onTap: () {
        Get.to(() => PDFContentScreen(file: file),
            transition: Transition.cupertino);
      },
      child: Container(child: SvgPicture.asset("assets/pdf-icon.svg")),
    );
  }

  Widget _buildOtherType() {
    return Container(color: Colors.red);
  }
}
