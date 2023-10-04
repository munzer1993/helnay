// ignore_for_file: prefer_const_constructors, await_only_futures

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/account_bottomnavbar_widget/account_bottomnavbar_widget.dart';
import 'package:project/view/widget/chat_list_bottomnavbar_widget/message_bottonnavbar_widget.dart';
import 'package:project/view/widget/home_bottom_nav_bar_widget/home_bottomnavbar_bar_widget.dart';
import 'package:project/view/widget/notification_bottomnavbar_widget/notification_bottomnavbar_widget.dart';

abstract class HomeScreenController extends GetxController {}

class HomeScreenControllerIMP extends HomeScreenController {
  var currentIndex = 0;

  RegistrationUserData? registrationUserData;
  MyServices myServices = Get.find();

  @override
  void onInit() async {
    String? data =
        await myServices.sharedPreferences.getString('registrationUser');
    registrationUserData = RegistrationUserData.fromJson(jsonDecode(data!));
    user__ID = registrationUserData!.id!;
    super.onInit();
  }

  var screen = [
    HomeBottomNaBarWidget(),
    MessageBottomNavBarWidget(),
    NotificationBottomNavBarWidget(),
    AccountBottomNavBarWidget(),
  ];

  List<IconData> listOfIcons = [
    CupertinoIcons.house,
    CupertinoIcons.chat_bubble_2,
    CupertinoIcons.bell,
    CupertinoIcons.person_crop_circle_fill,
  ];

  List<String> listOfStrings = [
    'Home'.toUpperCase(),
    'MESSAGE'.toUpperCase(),
    'Notification'.toUpperCase(),
    'Account'.toUpperCase(),
  ];

  changeIndex(index) {
    currentIndex = index;
    HapticFeedback.lightImpact();
    update();
  }
}
