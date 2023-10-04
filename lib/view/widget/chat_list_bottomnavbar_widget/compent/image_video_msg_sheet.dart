// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/link_api.dart';

class ImageVideoMsgSheet extends StatelessWidget {
  final String? image;
  final String selectedItem;
  final Function(String msg, String? image) onSendBtnClick;

  const ImageVideoMsgSheet(
      {Key? key,
      required this.image,
      required this.onSendBtnClick,
      required this.selectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController msgController = TextEditingController();
    return Container(
      margin: EdgeInsets.only(top: 70),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedIconTheme!
                        .color,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Text(
                  "Send Media",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer()
              ],
            ),
          ),
          const SizedBox(height: 1),
          Divider(color: Theme.of(context).primaryColorDark),
          const SizedBox(height: 10),
          Text('"Write Message"',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: selectedItem == 'Image'
                      ? Image.network(
                          '${AppLink.aImageBaseUrl}$image',
                          height: 170,
                          fit: BoxFit.cover,
                          // cacheKey: '${ConstRes.aImageBaseUrl}$image',
                        )
                      : Image.file(
                          File('$image'),
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).dialogBackgroundColor),
                  child: TextField(
                    controller: msgController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 9,
                    //cursorColor: ColorRes.darkOrange,
                    cursorHeight: 15,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 3, right: 5, top: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              onSendBtnClick(msgController.text, image);
            },
            child: Container(
              height: 40,
              width: Get.width / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).buttonTheme.colorScheme!.inversePrimary,
                      Theme.of(context).buttonTheme.colorScheme!.onInverseSurface,
                    ],
                  )),
              child: Center(
                child: Text(
                  'Send',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
