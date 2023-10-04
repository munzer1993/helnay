// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/app_photo.dart';

class LogoLoginwidget extends StatelessWidget {
  const LogoLoginwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppPhotoLink.logoHelnay,
          fit: BoxFit.contain,
          height: 120,
          color: Theme.of(context).primaryColorLight,
          width: Get.width,
        ),
        Text('WELCOME YOU !', style: Theme.of(context).textTheme.displayLarge),
        Text("Please Enter Your account to Login\n to Your account",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium),
        SizedBox(height: 50),
      ],
    );
  }
}
