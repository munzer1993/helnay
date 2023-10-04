import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/data_sorcue/edit_profile_datasource/edit_profile_datasource.dart';

abstract class SelectPhotoScreenController extends GetxController {
  void onImageRemove(int index);
  void onImageAdd();
  void onPlayButtonTap();
  void selectImages();
}

class SelectPhotoScreenControllerIMP extends SelectPhotoScreenController {
  late PageController pageController;
  List<String> imageList = [];
  StatusRequest? statusRequest;
  int pageIndex = 0;
  String fullName = '';
  int? age;
  int gender = 0;
  String address = '';
  String bioText = '';
  int currentImgIndex = 0;
  final ImagePicker imagePicker = ImagePicker();
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());
  List<File>? imageFileList = [];
  EditProfileDataSource editProfileDataSource =
      EditProfileDataSource(Get.find());

  @override
  void onInit() {
    getPrefsData();
    pageController = PageController(initialPage: 0, viewportFraction: 1.05)
      ..addListener(() {
        onMainImageChange();
      });
    super.onInit();
  }

  Future<void> getPrefsData() async {
    constantDataSource.getUserData().then((value) {
      fullName = value?.fullname ?? '';
      age = value?.age ?? 0;
      bioText = value?.bio ?? '';
      address = value?.live ?? '';
      update();
    });
  }

  void onMainImageChange() {
    if (currentImgIndex != pageController.page!.round()) {
      currentImgIndex = pageController.page!.round();
      update();
    }
  }

  @override
  void onImageRemove(int index) {
    imageFileList?.removeAt(index);
    update();
  }

  @override
  void onImageAdd() async {
    selectImages();
  }

  @override
  void onPlayButtonTap() {
    if (imageFileList == null || imageFileList!.isEmpty) {
      Get.snackbar("WATCH !!", "please select your Photo for your account ",
          snackPosition: SnackPosition.TOP);
      return;
    }
    Loader().lottieLoader();
    statusRequest = StatusRequest.loading;
    for (int i = 0; i < imageFileList!.length; i++) {
      String image = imageFileList![i].path;
      imageList.add(image);
    }
    editProfileDataSource.updateProfile(images: imageFileList).then((value) {
      Get.back();
      statusRequest = StatusRequest.success;
      update();
      Get.toNamed(AppRoutes.homeScreen);
    });
  }

  @override
  void selectImages() async {
    final selectedImages = await imagePicker.pickMultiImage(imageQuality: 25);
    if (selectedImages.isEmpty) return;
    if (selectedImages.isNotEmpty) {
      for (XFile image in selectedImages) {
        var images = File(image.path);
        imageFileList?.add(images);
      }
    }
    update();
  }
}
