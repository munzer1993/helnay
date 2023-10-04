// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class AccountProfileScreenController extends GetxController {
  void onInstagramTap();
  void onFBTap();
  void onYoutubeTap();
  void goBack();
  void onImageTap();
  void onEditProfileTap();
}

class AccountProfileScreenControllerIMP extends AccountProfileScreenController {
  RegistrationUserData? userData;
  bool isLoading = false;
  int currentImageIndex = 0;
  late PageController pageController;
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());
  StatusRequest? statusRequest;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0, viewportFraction: 1.01)
      ..addListener(() {
        onMainImageChange();
      });
    profileScreenApiCall();
    super.onInit();
  }

  void profileScreenApiCall() async {
    statusRequest = StatusRequest.loading;
    isLoading = true;
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      userData = RegistrationUserData.fromJson(response['data']);
      isLoading = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch ';
  }

  bool isSocialBtnVisible(String? socialLink) {
    if (socialLink != null) {
      return socialLink.contains("http://") || socialLink.contains("https://");
    } else {
      return false;
    }
  }

  @override
  void onFBTap() {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : _launchUrl(userData?.facebook ?? '');
  }

  @override
  void onInstagramTap() {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : _launchUrl(userData?.instagram ?? '');
  }

  @override
  void onYoutubeTap() {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : _launchUrl(userData?.youtube ?? '');
  }

  @override
  void goBack() {
    Get.back();
  }

  void onMainImageChange() {
    if (pageController.page!.round() != currentImageIndex) {
      currentImageIndex = pageController.page!.round();
      update();
    }
  }

  @override
  void onImageTap() {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : Get.toNamed(AppRoutes.userDetailsScreen, arguments: userData);
  }

  @override
  void onEditProfileTap() {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : Get.toNamed(AppRoutes.editProfileScreen)?.then((value) {
            profileScreenApiCall();
            update();
          });
  }

  void onMoreBtnTap() {
    Get.toNamed(AppRoutes.optionScreen);
  }
}
