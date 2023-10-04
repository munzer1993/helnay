// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/func/firebase/fun_firebase.dart';

class ChatListViewBottomNavBarWidget extends StatelessWidget {
  final String? name;
  final String? age;
  final String? msg;
  final String? time;
  final String? image;
  final bool newMsg;
  final bool? tickMark;
  const ChatListViewBottomNavBarWidget({
    super.key,
    this.name,
    this.age,
    this.msg,
    this.time,
    this.image,
    required this.newMsg,
    this.tickMark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin:
              const EdgeInsets.only(bottom: 6, top: 27, left: 17, right: 17),
          padding:
              const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 11),
          height: 74,
          width: Get.width,
          decoration: BoxDecoration(
            //color: Theme.of(context).buttonTheme.colorScheme!.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: image == null || image!.isEmpty
                    ? Image.asset(
                        AppPhotoLink.logoHelnay,
                        height: 53,
                        width: 53,
                      )
                    : Image.network(
                        '${AppLink.aImageBaseUrl}$image',
                        height: 53,
                        width: 53,
                        fit: BoxFit.cover,
                        errorBuilder: (context, url, error) {
                          return Image.asset(
                            AppPhotoLink.logoHelnay,
                            height: 53,
                            width: 53,
                          );
                        },
                      ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text('$name',
                                      softWrap: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                                Flexible(
                                  child: Text(
                                    ' ${age ?? ''}',
                                    style: const TextStyle(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: tickMark == true
                                      ? Icon(
                                          CupertinoIcons.placemark,
                                          size: 20.5,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                          Text(
                              FunFirebase.readTimestamp(
                                double.parse(time ?? ''),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 20,
                            child: Text(
                              '$msg',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: newMsg,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: newMsg
                                    ? LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .buttonTheme
                                              .colorScheme!
                                              .inversePrimary,
                                          Theme.of(context)
                                              .buttonTheme
                                              .colorScheme!
                                              .onInverseSurface,
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
