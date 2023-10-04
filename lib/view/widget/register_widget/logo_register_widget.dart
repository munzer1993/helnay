// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/app_photo.dart';

class LogoRegisterwidget extends StatelessWidget {
  const LogoRegisterwidget({super.key});

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
        Text('WELCOME AT HELENY!',
            style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 5),
        Text("NOW !! \n You can Regiter Your account for have new Featur",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 50),
      ],
    );
  }
}
