// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SignWithAppleAndGmailWidget extends StatelessWidget {
  final String logoAssets;
  final String logoName;
  final VoidCallback ontap;
  const SignWithAppleAndGmailWidget({
    super.key,
    required this.logoName,
    required this.logoAssets,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 6.h,
        width: Get.width / 2.3,
        decoration: BoxDecoration(
          color: Theme.of(context).buttonTheme.colorScheme!.background,
          borderRadius: BorderRadius.circular(6.sp),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              logoAssets,
              fit: BoxFit.contain,
              width: 5.w,
              height: 5.h,
            ),
            SizedBox(width: 2.w),
            Text(
              logoName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
