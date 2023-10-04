// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/signup_screen_datasorcue/signup_datasource.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class RegisterScreenController extends GetxController {
  void goBack();
  Future<void> onContinueTap();
}

class RegisterScreenControllerIMP extends RegisterScreenController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPwdController;
  late TextEditingController ageController;
  bool isShowPassword = true;
  bool isShowPasswordConf = true;
  IconData iconDate = CupertinoIcons.eye_slash_fill;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StatusRequest? statusRequest;
  MyServices myServices = Get.find();
  SignupDataSource signupDataSource = SignupDataSource(Get.find());
  RegistrationUserData? registrationUserData;

  @override
  void onInit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPwdController = TextEditingController();
    ageController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwdController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void goBack() {
    Get.back();
  }

  changeShowPassword() {
    if (isShowPassword == true) {
      isShowPassword = false;
      iconDate = CupertinoIcons.eye_solid;
    } else {
      isShowPassword = true;
      iconDate = CupertinoIcons.eye_slash_fill;
    }
    update();
  }

  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    try {
      return await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error !!", '${e.message}',
          snackPosition: SnackPosition.BOTTOM);
      Get.toNamed(AppRoutes.loginScreen);
      return null;
    }
  }

  @override
  Future<void> onContinueTap() async {
    Loader().lottieLoader();
    signUp(email: emailController.text, password: passwordController.text)
        .then((value) async {
      if (value == null) return;
      value.user?.sendEmailVerification();
      Get.back();
      statusRequest = StatusRequest.loading;
      Loader().lottieLoader();
      var response = await signupDataSource.signUpData(
        email: emailController.text,
        fullName: nameController.text,
        deviceToken: tokenID,
        loginType: 5,
      );
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        statusRequest = StatusRequest.success;

        registrationUserData = RegistrationUserData.fromJson(response['data']);
        Get.snackbar("SUCCESS ", "You have register successfully !",
            snackPosition: SnackPosition.BOTTOM);
        AppLink.aUserId = registrationUserData!.id!;
        if (registrationUserData != null) {
          await myServices.sharedPreferences
              .setString("registrationUser", jsonEncode(registrationUserData));
          Get.back();
          Get.toNamed(AppRoutes.loginScreen);
        }
      } else {
        statusRequest = StatusRequest.failure;
        Get.back();
        update();
      }
    });
  }
}
