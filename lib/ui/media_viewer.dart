import 'dart:io';

import 'package:iphoto/ui/media_single_viewer.dart';
import 'package:iphoto/utils.dart';
import 'package:flutter/material.dart';

class MediaViewer extends StatefulWidget {
  final ResourceType mediaType;
  final String mediaPath;

  const MediaViewer(
      {super.key, required this.mediaType, required this.mediaPath});

  @override
  State<MediaViewer> createState() => _MediaViewerFULState();
}

class _MediaViewerFULState extends State<MediaViewer> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                MediaSingleViewer(mediaPath: widget.mediaPath),
          ),
        );

        // if (isSelected == true) {
        //   setState(() {
        //     isSelected = false;
        //   });
        // }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            isSelected
                ? const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.center,
              // child: Image.file(File(widget.mediaPath)),
              child: Image.file(File(widget.mediaPath)),
            ),
          ],
        ),
      ),
    );
  }
}
