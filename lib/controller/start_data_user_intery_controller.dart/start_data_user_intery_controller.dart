// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/data_sorcue/edit_profile_datasource/edit_profile_datasource.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class StartDataUserInteryController extends GetxController {
  void getProfileApi();
  void onGenderTap();
  void onGenderChange(String value);
  void onNextTap();
  void onAllScreenTap();
}

class StartDataUserInteryControllerIMP extends StartDataUserInteryController {
  StatusRequest? statusRequest;
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());
  EditProfileDataSource editProfileDataSource =
      EditProfileDataSource(Get.find());
  RegistrationUserData? _registrationUserData;

  late TextEditingController addressController;
  late TextEditingController bioController;
  late TextEditingController ageController;

  FocusNode addressFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode ageFocus = FocusNode();

  String? fullName = '';
  String addressError = '';
  String bioError = '';
  String ageError = '';
  String latitude = '';
  String longitude = '';
  String gender = 'Female';
  bool showDropdown = false;
  double? long;
  double? lat;

  @override
  void onInit() {
    addressController = TextEditingController();
    bioController = TextEditingController();
    ageController = TextEditingController();
    long = Get.arguments['long'];
    lat = Get.arguments['lat'];
    longitude = long.toString();
    latitude = lat.toString();
    getProfileApi();
    super.onInit();
  }

  @override
  void dispose() {
    addressController.dispose();
    bioController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  void getProfileApi() async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      update();
      _registrationUserData = RegistrationUserData.fromJson(response['data']);
      fullName = _registrationUserData?.fullname;
      Get.back();
    } else {
      statusRequest = StatusRequest.failure;
      Get.back();
      update();
    }
  }

  @override
  void onAllScreenTap() {
    showDropdown = false;
    update();
  }

  @override
  void onGenderTap() {
    addressFocus.unfocus();
    bioFocus.unfocus();
    ageFocus.unfocus();
    showDropdown = !showDropdown;
    update();
  }

  @override
  void onGenderChange(String value) {
    gender = value;
    showDropdown = false;
    update();
  }

  @override
  void onNextTap() async {
    if (ageController.text.isEmpty) {
      Get.snackbar('ERROR !!', 'Please enter your age',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      ageFocus.requestFocus();
      return;
    }
    if (int.parse(ageController.text) < 18) {
      Get.snackbar('ERROR !!', 'You must be 18+',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    await editProfileDataSource
        .updateProfile(
      fullName: fullName,
      live: addressController.text,
      bio: bioController.text,
      age: ageController.text,
      gender: gender == 'Male'
          ? 1
          : gender == 'Female'
              ? 2
              : 3,
      latitude: latitude,
      longitude: longitude,
    )
        .then((value) {
      statusRequest = StatusRequest.success;
      update();
      Get.back();
      Get.toNamed(AppRoutes.selectPhotoScreen);
    });
    Get.back();
  }
}
