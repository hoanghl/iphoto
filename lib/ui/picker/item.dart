import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends StatelessWidget {
  final void Function() onSelectitem;
  final File? item;
  const Item({super.key, required this.item, required this.onSelectitem});

  @override
  Widget build(BuildContext context) {
    Color? colorItem = const Color.fromARGB(255, 238, 166, 190);
    Color? colorDir = Colors.yellow[100];
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    Color? colorFinal;
    Widget? child;
    if (item == null) {
      colorFinal = colorDir;
      child = Center(
        child: Text(
          "..",
          style: textStyle,
        ),
      );
    } else if (item!.statSync().type == FileSystemEntityType.directory) {
      colorFinal = colorDir;
      child = Center(
        child: Text(
          item!.path.split('/').last,
          style: textStyle,
        ),
      );
    } else {
      colorFinal = colorItem;

      if (lookupMimeType(item!.path)!.startsWith("image")) {
        child = FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: Image.file(item!).image,
          fit: BoxFit.cover,
          // width: double.infinity,
        );
      } else {
        child = Center(
          child: Text(
            item!.path.split('/').last,
            style: textStyle,
          ),
        );
      }
    }
    return Card(
      margin: const EdgeInsets.all(10),
      color: colorFinal,
      child: InkWell(
        onTap: onSelectitem,
        child: child,
      ),
    );
  }
}
