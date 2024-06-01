import 'dart:io';

import 'package:iphoto/data/protocol.dart';
import 'package:iphoto/utils.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:iphoto/ui/picker/item.dart';
import 'package:iphoto/ui/media_single_viewer.dart';

const String rootDir = "/storage/emulated/0";

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Directory dir = Directory(rootDir);
  bool isSelectMode = false;
  List<File> selectedFiles = [];

  void sendSelectedFiles() {
    // TODO: HoangLe [Jun-01]: Implement this

    var futures = <Future>[];
    for (var file in selectedFiles) {
      futures.add(sendResource(file.path));
    }
    Future.wait(futures);
  }

  Future<List<File>> getItemsInDir(Directory dir) async {
    List<File> ret = [];
    for (var x in await dir.list().toList()) {
      ret.add(File(x.path));
    }

    return ret;
  }

  void changeCwd(String path) {
    setState(() {
      dir = Directory(path);
    });
  }

  List<File> sortItemPaths(List<File> files) {
    List<File> pathDirs = [];
    List<File> pathFiles = [];

    for (var file in files) {
      if (file.statSync().type == FileSystemEntityType.directory) {
        pathDirs.add(file);
      } else if (file.statSync().type == FileSystemEntityType.file) {
        pathFiles.add(file);
      }
    }

    pathDirs.sort((a, b) => a.path.compareTo(b.path));
    pathFiles.sort((a, b) => a.path.compareTo(b.path));

    return pathDirs + pathFiles;
  }

  void onTap(File? file) {
    if (file == null) {
      // is directory, if not inSelectMode, tap means access
      if (!isSelectMode) {
        if (dir.parent.path != rootDir) {
          changeCwd(dir.parent.path);
        }
      }
    } else {
      switch (file.statSync().type) {
        case FileSystemEntityType.directory:
          // behave like case file == null
          if (!isSelectMode) {
            changeCwd(file.path);
          }
          break;
        case FileSystemEntityType.file:
          {
            if (isSelectMode) {
              // continue selecting: if file already selected, unselect file, otherwise add file to selected list
              if (selectedFiles.contains(file)) {
                selectedFiles.remove(file);
              } else {
                selectedFiles.add(file);
              }
              logger.i("selectedFiles: len: ${selectedFiles.length}");
            } else {
              // if file is image/video, open it
              String mime = lookupMimeType(file.path)!;
              if (mime.startsWith(RegExp(r'(image|video)'))) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          MediaSingleViewer(mediaPath: file.path)),
                );
              }
            }
            break;
          }
        default:
          // NOTE: HoangLe [Jun-01]: Shoudl consider other cases
          break;
      }
    }
  }

  void onLongTap(File file) {
    if (!isSelectMode) {
      isSelectMode = true;
      selectedFiles.add(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "File Explorer",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: sendSelectedFiles,
              icon: const Icon(
                Icons.send_sharp,
                size: 20,
              ))
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 173, 212, 174),
        margin: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getItemsInDir(dir),
          builder: (context, snapshot) => snapshot.hasData
              ? GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5 / 0.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  children: [
                    Item(
                      item: null,
                      onTap: onTap,
                      onLongTap: onLongTap,
                    ),
                    for (var file in sortItemPaths(snapshot.data!))
                      Item(
                        item: file,
                        onTap: onTap,
                        onLongTap: onLongTap,
                      )
                  ],
                )
              : const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
