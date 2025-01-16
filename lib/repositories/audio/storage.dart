import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  final fileName = 'audio.wav';

  Future<String> completePath() async {
    var directory = await getExternalStorageDirectory();
    var directoryPath = directory!.path;
    log("<Storage> Path got");

    await _createFile('$directoryPath/records/$fileName');

    return "$directoryPath/records/$fileName";
  }

  Future<void> _createFile(String directoryPath) async {
    var file = await File(directoryPath).create(recursive: true);
    //write to file
    log("<Storage> File created at: ${file.path}");
  }
}
