// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TopBarWidget extends StatelessWidget {
  final String fullName;
  final String age;
  const TopBarWidget({super.key, required this.age, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 2.sp),
      width: Get.width,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fullName, style: Theme.of(context).textTheme.displayLarge),
          Text(age, style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    );
  }
}
