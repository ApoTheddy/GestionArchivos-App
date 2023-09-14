import "dart:convert";
import "dart:io";

import "package:gfilesapp/models/FileModel.dart";
import "package:http/http.dart" as http;
import "package:image_picker/image_picker.dart";

class FileService {
  Future<List<FileModel>> getFiles() async {
    List<FileModel> files = [];
    try {
      http.Response response =
          await http.get(Uri.parse("http://192.168.1.7:3000/files"));

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        for (Map<String, dynamic> file in jsonData) {
          files.add(FileModel.fromJson(file));
        }
      }
    } catch (err) {
      print("Error: $err");
    }

    return files;
  }

  Future<List<FileModel>> getOnlyPhotos() async {
    List<FileModel> files = [];
    try {
      http.Response response =
          await http.get(Uri.parse("http://192.168.1.7:3000/photos"));

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        for (Map<String, dynamic> file in jsonData) {
          files.add(FileModel.fromJson(file));
        }
      }
    } catch (err) {
      print("error");
      print(err);
    }

    return files;
  }

  Future<List<String>> getDirs() async {
    List<String> dirs = [];

    try {
      http.Response response =
          await http.get(Uri.parse("http://192.168.1.7:3000/dirs"));

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        for (String dir in jsonData) {
          dirs.add(dir);
        }
      }
    } catch (err) {
      print("error");
      print(err);
    }

    return dirs;
  }

  Future<FileModel?> getFile(int id) async {
    FileModel? file;
    try {
      http.Response response =
          await http.get(Uri.parse("http://192.168.1.7:3000/files/$id"));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        file = FileModel.fromJson(jsonData);
      }
    } catch (err) {
      print("Error: $err");
    }
    return file;
  }

  Future<List<FileModel>> getFilesByDirName(String dirname) async {
    List<FileModel> files = [];
    try {
      http.Response response = await http
          .get(Uri.parse("http://192.168.1.7:3000/files/search/$dirname"));

      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body);
        for (Map<String, dynamic> file in jsonData) {
          files.add(FileModel.fromJson(file));
        }
      }
    } catch (err) {
      print("Error: $err");
    }

    return files;
  }

  Future<FileModel?> uploadFile(XFile file, String? dirname) async {
    FileModel? newFile;
    final url = Uri.parse("http://192.168.1.7:3000/files");
    final File realFile = File(file.path);
    var request = http.MultipartRequest("POST", url);

    if (dirname != null && dirname.isNotEmpty) {
      request.fields["dirname"] = dirname;
    }
    try {
      request.files
          .add(await http.MultipartFile.fromPath("file", realFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        newFile = FileModel.fromJson(
            json.decode(await response.stream.bytesToString()));
      }
    } catch (err) {
      print("Error: $err");
    }

    return newFile;
  }

  Future<bool> createDir(String dirname) async {
    bool isCreate = false;
    try {
      http.Response response = await http.post(
          Uri.parse("http://192.168.1.7:3000/files/dir"),
          body: json.encode({"dirname": dirname}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        isCreate = true;
      }
    } catch (err) {
      print("Error: $err");
    }
    return isCreate;
  }

  Future<void> removeFileById(int id) async {
    try {
      http.Response response =
          await http.delete(Uri.parse("http://192.168.1.7:3000/files/$id"));

      if (response.statusCode == 200) {
        print("Eliminado correctamente");
      } else {
        print("Ocurrio un problema al eliminar");
      }
    } catch (err) {
      print("Error: $err");
    }
  }

  Future<bool> removeDir(String foldername) async {
    bool isDeleted = false;
    try {
      http.Response response = await http.delete(
          Uri.parse("http://192.168.1.7:3000/files/dir/delete"),
          body: json.encode({"dirname": foldername}));

      if (response.statusCode == 200) {
        isDeleted = true;
      }
    } catch (err) {
      print("Error: $err");
    }
    return isDeleted;
  }
}
