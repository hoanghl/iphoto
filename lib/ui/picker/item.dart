import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends StatefulWidget {
  final void Function(File? file) onTap;
  final void Function(File file) onLongTap;
  final File? item;

  const Item(
      {super.key,
      required this.item,
      required this.onTap,
      required this.onLongTap});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isSelected = false;

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
    if (widget.item == null) {
      colorFinal = colorDir;
      child = Center(
        child: Text(
          "..",
          style: textStyle,
        ),
      );
    } else if (widget.item!.statSync().type == FileSystemEntityType.directory) {
      colorFinal = colorDir;
      child = Center(
        child: Text(
          widget.item!.path.split('/').last,
          style: textStyle,
        ),
      );
    } else {
      colorFinal = colorItem;

      if (lookupMimeType(widget.item!.path)!.startsWith("image")) {
        child = FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: Image.file(widget.item!).image,
          fit: BoxFit.cover,
          // width: double.infinity,
        );
      } else {
        child = Center(
          child: Text(
            widget.item!.path.split('/').last,
            style: textStyle,
          ),
        );
      }
    }
    return InkWell(
      onTap: () {
        widget.onTap(widget.item);

        if (isSelected) {
          setState(() {
            isSelected = false;
          });
        }
      },
      onLongPress: () {
        if (widget.item != null) {
          widget.onLongTap(widget.item!);
          if (!isSelected) {
            setState(() {
              isSelected = true;
            });
          }
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(10),
              color: colorFinal,
              child: child,
            ),
          ),
          isSelected
              ? Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.check_box,
                      size: 35,
                      color: Colors.green,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
