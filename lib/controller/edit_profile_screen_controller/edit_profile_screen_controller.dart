// ignore_for_file: await_only_futures

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/data_sorcue/edit_profile_datasource/edit_profile_datasource.dart';
import 'package:project/data/models/get_intersrt.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class EditProfileScreenController extends GetxController {
  void onClipTap(String value);
  void onImageRemove(int index);
  void onImageAdd();
  void onBackBtnTap();
  void onAllScreenTap();
  void onGenderTap();
  void onGenderChange(String value);
  Future<void> onSaveTap();
  void onPreviewTap();
  void selectImages();
}

class EditProfileScreenControllerIMP extends EditProfileScreenController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();

  FocusNode ageFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode youtubeFocus = FocusNode();
  FocusNode facebookFocus = FocusNode();
  FocusNode fullNameFocus = FocusNode();
  FocusNode instagramFocus = FocusNode();

  List<Interest>? hobbiesList = [];
  List<String> selectedList = [];
  GetInterest? getInterest;
  RegistrationUserData? registrationUserData;
  MyServices myServices = Get.find();

  String latitude = '';
  String longitude = '';
  String gender = 'Female';
  String fullNameError = '';
  String bioError = '';
  String aboutError = '';
  String addressError = '';
  String ageError = '';
  String? email;
  EditProfileDataSource editProfileDataSource =
      EditProfileDataSource(Get.find());
  StatusRequest? statusRequest;
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());

  List<String> deleteIds = [];
  List<String?> interestList = [];
  List<Images>? imageList = [];
  List<File>? imageFileList = [];

  bool showDropdown = false;
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getEditProfileApiCall();
    getInterestApiCall();
    super.onInit();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    bioController.dispose();
    aboutController.dispose();
    ageController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  @override
  void onClipTap(String value) {
    bool selected = selectedList.contains(value);
    if (selected) {
      selectedList.remove(value);
    } else {
      selectedList.add(value);
    }
    update();
  }

  void getInterestApiCall() async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    update();
    var response = await editProfileDataSource.getInterest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      Get.back();
      getInterest = GetInterest.fromJson(response);
      if (getInterest != null && getInterest!.status!) {
        hobbiesList = getInterest!.data;
        update();
        getPrefUser();
      }
    } else {
      statusRequest = StatusRequest.failure;
      Get.back();
      update();
    }
  }

  void getEditProfileApiCall() async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    isLoading = true;
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      Get.back();
      registrationUserData = RegistrationUserData.fromJson(response['data']);
      imageList = registrationUserData?.images;
      fullNameController.text = registrationUserData?.fullname ?? '';
      bioController.text = registrationUserData?.bio ?? '';
      aboutController.text = registrationUserData?.about ?? '';
      addressController.text = registrationUserData?.live ?? '';
      ageController.text = registrationUserData?.age?.toString() ?? '';
      gender = registrationUserData?.gender == 1
          ? 'Male'
          : registrationUserData?.gender == 2
              ? 'Female'
              : 'Other';
      instagramController.text = registrationUserData?.instagram ?? '';
      facebookController.text = registrationUserData?.facebook ?? '';
      youtubeController.text = registrationUserData?.youtube ?? '';
      latitude = await myServices.sharedPreferences.getString('latitude') ?? '';
      longitude =
          await myServices.sharedPreferences.getString('longitude') ?? '';
      email = registrationUserData?.identity;
      await constantDataSource.saveUser(registrationUserData);
      isLoading = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      Get.back();
      update();
    }
  }

  void getPrefUser() async {
    constantDataSource.getUserData().then((value) {
      value?.interests?.map((e) {
        selectedList.add(e.id.toString());
      }).toList();
      update();
    });
  }

  @override
  void onImageRemove(int index) {
    File? imageOne;
    for (File image in imageFileList!) {
      if (image.path == imageList?[index].image) {
        imageOne = image;
      }
    }
    if (imageOne != null) {
      imageFileList?.remove(imageOne);
    }
    deleteIds.add(imageList![index].id.toString());
    imageList?.removeAt(index);
    update();
  }

  @override
  void onImageAdd() async {
    selectImages();
  }

  @override
  void onBackBtnTap() {
    Get.back();
  }

  @override
  void onAllScreenTap() {
    showDropdown = false;
    update();
  }

  @override
  void onGenderTap() {
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
  Future<void> onSaveTap() async {
    updateProfileApiCall();
  }

  @override
  void onPreviewTap() {}

  @override
  void selectImages() async {
    final selectedImages = await imagePicker.pickMultiImage(imageQuality: 25);
    if (selectedImages.isEmpty) return;
    if (selectedImages.isNotEmpty) {
      for (XFile image in selectedImages) {
        var images = File(image.path);
        imageFileList?.add(images);
        imageList?.add(Images(id: -123, userId: user__ID, image: images.path));
      }
    }
    update();
  }

  void updateProfileApiCall() {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    update();
    editProfileDataSource
        .updateProfile(
      latitude: latitude,
      longitude: longitude,
      images: imageFileList,
      bio: bioController.text,
      age: ageController.text,
      instagram: instagramController.text,
      about: aboutController.text,
      facebook: facebookController.text,
      youtube: youtubeController.text,
      live: addressController.text,
      gender: gender == 'Male' ? 1 : 2,
      fullName: fullNameController.text,
      deleteImageIds: deleteIds,
      interest: selectedList,
    )
        .then((value) async {
      statusRequest = StatusRequest.success;
      Get.back();
      update();
    });
    Get.back();
    update();
  }
}
