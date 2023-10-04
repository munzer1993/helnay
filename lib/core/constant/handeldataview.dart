// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/statusrequest.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest? statusRequest;
  final Widget? widget;
  const HandlingDataView({super.key, this.widget, this.statusRequest});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Lottie.asset(AppPhotoLink.loading,
                        width: Get.width, height: Get.height / 1.6)),
              ],
            ),
          )
        : statusRequest == StatusRequest.offlinefailure
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Lottie.asset(AppPhotoLink.failerServer,
                            width: Get.width, height: Get.height / 1.6)),
                  ],
                ),
              )
            : statusRequest == StatusRequest.serverfailure
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Lottie.asset(AppPhotoLink.failerServer,
                                width: Get.width, height: Get.height / 1.6)),
                      ],
                    ),
                  )
                : statusRequest == StatusRequest.failure
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Lottie.asset(
                              AppPhotoLink.failerServer,
                            )),
                          ],
                        ),
                      )
                    : statusRequest == StatusRequest.exeptions
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Lottie.asset(
                                        AppPhotoLink.failerServer,
                                        width: Get.width,
                                        height: Get.height / 1.6)),
                              ],
                            ),
                          )
                        : widget!;
  }
}
