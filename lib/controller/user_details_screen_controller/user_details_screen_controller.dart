// ignore_for_file: await_only_futures

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/user_details_info_datasource/user_details_info_datasource.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/user_details/update_save.dart';
import 'package:project/data/models/users/get_profile_model.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:share_plus/share_plus.dart';

abstract class UserDetailsScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  void goBack();

  void onChatWithBtnTap();
  void onReportTap();
  void onShareProfileBtnTap();
  void onLikeBtnTap();
}

class UserDetailsScreenControllerIMP extends UserDetailsScreenController {
  RegistrationUserData? users;
  RegistrationUserData? _registrationUserData;
  UserDetailsScreenDataSource userDetailsScreenDataSource =
      UserDetailsScreenDataSource(Get.find());
  StatusRequest? statusRequest;
  bool save = false;
  MyServices myServices = Get.find();
  int? userId;
  bool isLoading = false;
  double distance = 0.0;
  late final AnimationController controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 350), vsync: this, value: 1.0);
  bool like = false;
  UpdateSavedProfile? updateSavedProfile;
  GetProfile? getProfile;
  String blockUnBlock = "Block";
  String? latitude = '';
  String? longitude = '';

  @override
  void onInit() {
    if (Get.arguments is int) {
      userId = Get.arguments;
    } else if (Get.arguments is String) {
      userId = int.parse(Get.arguments);
    } else {
      users = Get.arguments;
    }
    userDetailApiCall();
    super.onInit();
  }

  @override
  void dispose() {
    controllerAnimation.dispose();
    super.dispose();
  }

  @override
  void goBack() {
    Get.back();
  }

  void shareLink(RegistrationUserData? userData) async {
    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: userData?.fullname ?? '',
      imageUrl: '${AppLink.aImageBaseUrl}${userData?.images?[0].image}',
      contentDescription: userData?.about ?? '',
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('user_id', userData?.id),
    );
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Share.share(
        'Check out this Profile ${response.result}',
        subject: 'Look ${userData?.fullname}',
      );
    } else {}
  }

  @override
  void onChatWithBtnTap() {
    userDetailsScreenDataSource.getUserData().then((value) {
      ChatUser chatUser = ChatUser(
        age: '${users?.age ?? ''}',
        city: users?.live ?? '',
        image: users?.images == null || users!.images!.isEmpty
            ? ''
            : users?.images?[0].image,
        userIdentity: users?.identity,
        userid: users?.id,
        isNewMsg: false,
        isHost: users?.isVerified == 2 ? true : false,
        date: DateTime.now().millisecondsSinceEpoch.toDouble(),
        username: users?.fullname,
      );
      Conversation conversation = Conversation(
        block: _registrationUserData?.blockedUsers?.contains('${users?.id}') ==
                true
            ? true
            : false,
        blockFromOther:
            users?.blockedUsers?.contains('${_registrationUserData?.id}') ==
                    true
                ? true
                : false,
        conversationId: '${value?.identity}${users?.identity}',
        deletedId: '',
        time: DateTime.now().millisecondsSinceEpoch.toDouble(),
        isDeleted: false,
        isMute: false,
        lastMsg: '',
        newMsg: '',
        user: chatUser,
      );
      Get.toNamed(AppRoutes.chatScreen, arguments: conversation)?.then((value) {
        registrationUserApiCall();
      });
    });
  }

  @override
  void onReportTap() {
    Get.toNamed(AppRoutes.reportUsersScreen, arguments: {
      'reportName': users?.fullname,
      'reportImage': users?.images == null || users!.images!.isEmpty
          ? ''
          : users?.images?[0].image,
      'reportAge': users?.age.toString() ?? '',
      'reportAddress': users?.live
    });
  }

  @override
  void onShareProfileBtnTap() {
    shareLink(users);
  }

  double calculateDistance({lat1, lon1, lat2, lon2}) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> saveUser(RegistrationUserData? value) async {
    if (value != null) {
      await myServices.sharedPreferences
          .setString('registrationUser', jsonEncode(value));
    }
  }

  @override
  void onLikeBtnTap() async {
    var response = await userDetailsScreenDataSource.updateLikedProfile(
        profileId: users?.id);
    updateSavedProfile = UpdateSavedProfile.fromJson(response);
    saveUser(updateSavedProfile!.data);
    like == true
        ? null
        : await userDetailsScreenDataSource.notifyLikeUser(
            userId: users?.id ?? 0, type: 1);
    like = !like;
    update();
  }

  Future<void> userProfileApiCall() async {
    isLoading = true;
    var response = await userDetailsScreenDataSource.getProfile(
        userID: userId ?? users?.id);
    getProfile = GetProfile.fromJson(response);
    users = getProfile?.data;
    isLoading = false;
    update();
  }

  Future<void> registrationUserApiCall() async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    var response =
        await userDetailsScreenDataSource.getProfile(userID: user__ID);
    getProfile = GetProfile.fromJson(response);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      update();
      _registrationUserData = getProfile?.data;
      blockUnBlock =
          _registrationUserData?.blockedUsers?.contains('${users?.id}') == true
              ? "UnBlock"
              : "Block";
      save = _registrationUserData?.savedprofile?.contains('${users?.id}') ??
          false;
      like = _registrationUserData?.likedprofile?.contains("${users?.id}") ??
          false;
      Get.back();
      update();
    } else {
      Get.back();
    }
  }

  void userDetailApiCall() async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    await userProfileApiCall().then((value) {
      registrationUserApiCall();
      statusRequest = StatusRequest.success;
      Get.back();
      update();
    });

    latitude = await myServices.sharedPreferences.getString("latitude") ?? '';
    longitude = await myServices.sharedPreferences.getString("longitude") ?? '';

    if (latitude != null &&
        latitude!.isNotEmpty &&
        latitude != '0.0' &&
        users?.lattitude != null &&
        users!.lattitude!.isNotEmpty &&
        users?.lattitude != '0.0') {
      distance = calculateDistance(
        lat1: double.parse(latitude ?? '0.0'),
        lon1: double.parse(longitude ?? '0.0'),
        lat2: double.parse(users?.lattitude ?? '0.0'),
        lon2: double.parse(users?.longitude ?? '0.0'),
      );
    } else {
      Get.back();
      distance = 0;
    }
    update();
  }
}
