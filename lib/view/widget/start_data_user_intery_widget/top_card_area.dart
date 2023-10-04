// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/view/widget/start_data_user_intery_widget/text_field_area/text_field_controller.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class TopCardArea extends StatelessWidget {
  final String? fullName;

  TopCardArea({Key? key, required this.fullName}) : super(key: key);

  final TextFieldController controller = Get.put(TextFieldController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(AppPhotoLink.logoHelnay),
                fit: BoxFit.contain,
              ),
            ),
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          fullName == null || fullName!.isEmpty
                              ? const TextSpan(text: '')
                              : TextSpan(
                                  text: '${capitalize('$fullName')} ',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                              text: controller.age.value,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(CupertinoIcons.placemark, size: 13),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(controller.address.value,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(controller.bio.value,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
