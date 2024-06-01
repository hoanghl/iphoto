import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iphoto/ui/media_single_viewer.dart';
import 'package:iphoto/ui/picker/item.dart';

class Picker extends StatefulWidget {
  const Picker({super.key});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Directory dir = Directory("/storage/emulated/0");

  Future<List<File>> getItemsInDir(Directory dir) async {
    List<File> ret = [];
    for (var x in await dir.list().toList()) {
      ret.add(File(x.path));
    }

    return ret;
  }

  void onSelectItem(File file) {
    if (file.statSync().type == FileSystemEntityType.directory) {
      setState(() {
        dir = Directory(file.path);
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MediaSingleViewer(mediaPath: file.path)),
      );
    }
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.send_sharp))
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
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    Item(
                      item: null,
                      onSelectitem: () {
                        onSelectItem(File(dir.parent.path));
                      },
                    ),
                    for (var file in sortItemPaths(snapshot.data!))
                      Item(
                        item: file,
                        onSelectitem: () {
                          onSelectItem(file);
                        },
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
