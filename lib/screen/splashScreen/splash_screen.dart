import 'package:flutter/material.dart';
import 'package:grap_food/core/assets/app_assets.dart';
import 'package:grap_food/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _padding = 70;

  @override
  initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });

    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        _padding = 16;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedPadding(
          padding: EdgeInsets.all(_padding),
          duration: const Duration(seconds: 2),
          child: Image(image: AssetImage(AppAssets.logo)),
        ),
      ),
    );
  }
}
