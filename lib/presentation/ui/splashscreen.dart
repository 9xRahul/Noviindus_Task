import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          color: ColorConfig.primary,
          image: DecorationImage(
            image: AssetImage('assets/img/sp.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
