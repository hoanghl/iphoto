import 'package:logger/logger.dart';

enum ResourceType { video, image, thumbnail }

class PathResource {
  ResourceType resType;
  String resPath;

  PathResource({
    required this.resType,
    required this.resPath,
  });
}

var logger = Logger(
  printer: PrettyPrinter(
    colors: true,
    methodCount: 5,
    errorMethodCount: 3,
    lineLength: 100,
    printEmojis: true,
    printTime: true,
  ),
);
