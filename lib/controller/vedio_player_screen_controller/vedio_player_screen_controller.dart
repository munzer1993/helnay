// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:get/get.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:video_player/video_player.dart';

abstract class VedioPlayerScreenController extends GetxController {
  void videoInit();
  void onBackBtnTap();
  void onPlayPauseTap();
}

class VedioPlayerScreenControllerIMP extends VedioPlayerScreenController {
  String videoPath = '';
  late VideoPlayerController videoPlayerController;
  late Timer timer;
  late Duration duration;
  bool isExceptionError = false;

  @override
  void onInit() {
    videoPath = Get.arguments;
    videoInit();
    super.onInit();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    isExceptionError ? null : timer.cancel();
    super.dispose();
  }

  @override
  void videoInit() {
    duration = const Duration();
    videoPlayerController = VideoPlayerController.network(
      '${AppLink.aImageBaseUrl}$videoPath',
    )..initialize().then((value) {
        videoPlayerController.play();
        timer = Timer.periodic(videoPlayerController.value.position, (timer) {
          duration = videoPlayerController.value.position;
          update();
        });
      }).onError((e, e1) {
        isExceptionError = true;
        update();
      }).catchError((e) {
        isExceptionError = true;
        update();
      });
  }

  @override
  void onBackBtnTap() {
    Get.back();
  }

  @override
  void onPlayPauseTap() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
      update();
    } else {
      videoPlayerController.play();
      update();
    }
  }
}
