import "package:path/path.dart";

class FileModel {
  int id;
  String createdat;
  String filename;
  String filepath;
  String? dirname;
  String uniquename;

  FileModel(
      {required this.id,
      required this.createdat,
      required this.filename,
      required this.filepath,
      required this.dirname,
      required this.uniquename});

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
        id: json["ID"],
        createdat: json["CreatedAt"],
        filename: json["filename"],
        filepath: "http://localhost:3000/${json["filepath"]}",
        dirname: json["dirname"],
        uniquename: json["uniquename"]);
  }

  Map<String, dynamic> toJson() {
    return {"file": filename, "dirname": dirname};
  }

  String get ext => extension(filename);
}
