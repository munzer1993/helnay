// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/on_boarding_datasorcue/on_boarding_data_sorcue.dart';

abstract class OnBoardingController extends GetxController {
  void next();
  void onPageChange(int index);
}

class OnBoardingContollerImp extends OnBoardingController {
  late PageController pageController;
  MyServices myServise = Get.find();
  int currentPage = 0;
  double? long, lat;

  @override
  void next() {
    currentPage++;
    if (currentPage > onBoardingList.length - 1) {
      myServise.sharedPreferences.setString("step", "1");
      Get.bottomSheet(EulaSheet(eulaAcceptClick: eulaAcceptClick),
          isScrollControlled: true, isDismissible: false);
    } else {
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    }
  }

  void eulaAcceptClick() async {
    Get.back();
    Get.offAllNamed(AppRoutes.loginScreen,
        arguments: {"long": long, "lat": lat});
  }

  @override
  onPageChange(int index) {
    currentPage = index;

    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    long = Get.arguments['long'];
    lat = Get.arguments['lat'];
    super.onInit();
  }
}
