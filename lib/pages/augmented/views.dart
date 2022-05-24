import 'package:flutter/material.dart';
import 'package:ar_core/ar_core.dart';
import 'package:camera/camera.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.description);
  }
  runApp(AugmentedR());
}
class AugmentedR extends StatefulWidget {
   dynamic args = Get.arguments;


  @override
  State<AugmentedR> createState() => _AugmentedRState(this.args);
}

class _AugmentedRState extends State<AugmentedR> {
    final args;
  _AugmentedRState(this.args);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Augmented(args[0]),
    );
  }
}