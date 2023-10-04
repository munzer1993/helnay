// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/app_photo.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          AppPhotoLink.resetPassword,
          fit: BoxFit.fill,
          height: Get.height / 3,
          width: Get.width,
        ),
        Text('FORGET YOUR EMAIL',
            style: Theme.of(context).textTheme.displayLarge),
        Text(
            "If you forget your password don't worry \nNow You can change your password By check message box in your email and you could change it !!\nPLEASE ENTER YOUR E-MAIL",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 50),
      ],
    );
  }
}
