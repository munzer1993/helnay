// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (myServices.sharedPreferences.getString("step") == "1") {
      if (myServices.sharedPreferences.getBool('isLogin') == true) {
        return const RouteSettings(name: AppRoutes.homeScreen);
      } else {
        return const RouteSettings(name: AppRoutes.loginScreen);
      }
    }
  }
}
