import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:iphoto/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

const String host = "192.168.0.163";
const int port = 30556;

Future<List> getResInfo() async {
  var uri = Uri(
    scheme: "http",
    host: host,
    port: port,
    path: "res/",
    queryParameters: {'res_type': 'image', 'quantity': '4'},
  );
  logger.i("Sent GET to ${uri.toString()}");
  var resp = await http.get(uri);

  var output = jsonDecode(resp.body) as List;

  return output;
}

Future<PathResource> getRes(
  int resId,
  String resName,
  ResourceType resType,
) async {
  var uri = Uri(scheme: "http", host: host, port: port, path: "res/$resId/");
  var resp = await http.get(uri);
  logger.i("Sent GET to ${uri.toString()}");

  // Create filepath to save resource
  var path = p.join(
    (await getApplicationDocumentsDirectory()).path,
    resType.name,
    resName,
  );

  logger.d("Done 1: $path");

  // Save resource
  var file = File(path);
  file.createSync(recursive: true);
  await file.writeAsBytes(resp.bodyBytes);

  logger.d("Done 2");

  return PathResource(resType: resType, resPath: path);
}

Future sendResource(String path) async {
  var uri = Uri(scheme: "http", host: host, port: port, path: "res/");
  var request = http.MultipartRequest('POST', uri);

  String mime = lookupMimeType(path)!;

  request.files.add(
    await http.MultipartFile.fromPath(
      "upload_file",
      path,
      contentType: MediaType(mime.split('/')[0], mime.split('/')[1]),
    ),
  );

  return request.send();
  // print("Status code: ${response.statusCode}");
}

void readData(Socket socket, path) async {
  File file;

  if (path != null) {
    file = File(path);

    var futureBytes = file.readAsBytes();
    futureBytes.then((Uint8List value) {
      print("Total bytes: ${value.length}");
      // var tmp = Uint8List(8)
      //   ..buffer.asByteData().setInt64(0, value.length, Endian.big);
      // socket.add(tmp);

      socket.add(value);
    });
  }
}
