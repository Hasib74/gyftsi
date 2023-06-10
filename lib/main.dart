import 'package:flutter/material.dart';
import 'package:grap_food/screen/home_screen.dart';
import 'package:grap_food/screen/splashScreen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.storage.request();
  runApp(MaterialApp(home: SplashScreen()));
}
