// ignore_for_file: await_only_futures, non_constant_identifier_names, unused_element, prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/home_bottomnavbar_wdget_datasource/home_bottomnavbar_widget_datasource.dart';
import 'package:project/data/models/home_model/get_explore_model.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class HomeBottomNaBarWidgetController extends GetxController {
  bool isSocialBtnVisible(String? socialLink);
  void onInstagramTap();
  void onFBTap();
  void onYoutubeTap();
  void onLiveBtnTap();
  void onImageTap(int user_id, int index);
  void goBack();
}

class HomeBottomNaBarWidgetControllerIMP
    extends HomeBottomNaBarWidgetController {
  List<RegistrationUserData>? user_data;
  MyServices myServices = Get.find();
  HomeBottomNaBarWidgetDataSource homeBottomNaBarWidgetDataSource =
      HomeBottomNaBarWidgetDataSource(Get.find());
  StatusRequest? statusRequest;
  GetExploreScreen? getExploreScreen;
  int currentUserIndex = 0;
  bool isLoading = false;
  RegistrationUserData? users;

  @override
  void onInit() async {
    getAllExploreScreen();
    super.onInit();
  }

  void getAllExploreScreen() async {
    statusRequest = StatusRequest.loading;
    update();
    Timer(const Duration(seconds: 1), () async {
      var response = await homeBottomNaBarWidgetDataSource.getDataUsers();
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        update();
        getExploreScreen = GetExploreScreen.fromJson(response);
        user_data = getExploreScreen!.data;
        isLoading = false;
      } else {
        statusRequest = StatusRequest.failure;
        update();
      }
    });
  }

  @override
  bool isSocialBtnVisible(String? socialLink) {
    if (socialLink != null) {
      return socialLink.contains("http://") || socialLink.contains("https://");
    } else {
      return false;
    }
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
    )) throw 'Could not launch ';
  }

  @override
  void onFBTap() {
    _launchUrl(user_data?[currentUserIndex].facebook ?? '');
  }

  @override
  void onInstagramTap() {
    _launchUrl(user_data?[currentUserIndex].instagram ?? '');
  }

  @override
  void onYoutubeTap() {
    _launchUrl(user_data?[currentUserIndex].youtube ?? '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onLiveBtnTap() {
    // Get.to(() => const PremiumScreen());
  }

  @override
  void onImageTap(int user_id, int index) async {
    statusRequest = StatusRequest.loading;
    var response =
        await homeBottomNaBarWidgetDataSource.getProfileData(userID: user_id);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      update();
      users = RegistrationUserData.fromJson(response['data']);
      if (users?.isBlock == 1) {
        CustomDialogWidget(
          text: "Back",
          title: "User Blocked",
          descriptions:
              "We Sorry to tell you that this user is blocked from admins",
          iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
          callback: goBack,
        );
      } else {
        Get.toNamed(
          AppRoutes.userDetailsScreen,
          arguments: user_data?[index],
        );
      }
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void goBack() {
    Get.back();
  }
}
