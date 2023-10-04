// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/binding/initial_bindings.dart';
import 'package:project/core/routes/app_routes.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/core/theme/theme_color.dart';
import 'package:sizer/sizer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

MyServices myServices = Get.find();
ThemeMode themeMode = ThemeMode.system;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void initialize() {
    if (myServices.sharedPreferences.getBool('theme') == true) {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (myServices.sharedPreferences.getBool('theme') == false) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, devicetype) => GetMaterialApp(
        onInit: initialize,
        debugShowCheckedModeBanner: false,
        theme: AppColor.customLightThem,
        darkTheme: AppColor.customDarkThem,
        themeMode: ThemeMode.system,
        title: 'Heleny',
        initialBinding: InitialBindings(),
        getPages: routes,
      ),
    );
  }
}
