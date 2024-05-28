import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MediaSingleViewer extends StatelessWidget {
  final String mediaPath;
  const MediaSingleViewer({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: Image.file(File(mediaPath)).image,
      ),
    );
  }
}
