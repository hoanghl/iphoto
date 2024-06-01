import 'package:iphoto/ui/picker/picker_screen.dart';
import 'package:iphoto/utils.dart';
// import 'package:iphoto/ui/viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  Future<void> requesPermissions() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      logger.i("Storage permission not granted");
      await Permission.storage.request();
      await Permission.videos.request();
      await Permission.photos.request();

      logger.i("All necessary Permission granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const Viewer(),
      home: FutureBuilder(
        future: requesPermissions(),
        builder: (context, snapshot) => !snapshot.hasData
            ? const Picker()
            : const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
      ),
      // home: const Picker(),
    );
  }
}
