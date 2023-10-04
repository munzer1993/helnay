// ignore_for_file: await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/data_sorcue/option_screen_datasource/option_screen_data_source.dart';
import 'package:project/data/models/report_model/report_model.dart';
import 'package:project/data/models/users/delete_account.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/web_view_widget/web_view_widget.dart';

abstract class OptionScreenController extends GetxController {
  void onBackBtnTap();
  void onLogoutTap();
  void onDeleteYesBtnClick();
  void onNoBtnClick();
  Future<void> onMoreBtnTap(String value);
}

class OptionScreenControllerIMP extends OptionScreenController {
  bool notificationEnable = false;
  bool showMeOnMap = false;
  bool goAnonymous = false;
  int? loginType;
  int? verificationProcess = 0;
  bool isLoading = false;
  int? deleteId;
  Report? _report;
  DeleteAccount? _deleteAccount;
  MyServices myServices = Get.find();
  RegistrationUserData? userData;
  FirebaseAuth auth = FirebaseAuth.instance;
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());
  StatusRequest? statusRequest;
  OptionDataSource optionDataSource = OptionDataSource(Get.find());
  final db = FirebaseFirestore.instance;
  double? long;
  double? lat;
  String latitude = '';
  String longitude = '';
  bool isTheme = false;

  @override
  void onInit() {
    getProfileApiCall();
    getPref();
    super.onInit();
  }

  @override
  void onBackBtnTap() {
    Get.back();
  }

  void getProfileApiCall() async {
    statusRequest = StatusRequest.loading;
    isLoading = true;
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      userData = RegistrationUserData.fromJson(response['data']);
      deleteId = userData?.id;
      verificationProcess = userData?.isVerified == 0
          ? 0
          : userData?.isVerified == 1
              ? 1
              : 2;
      isLoading = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  void getPref() {
    constantDataSource.getUserData().then((value) {
      if (value == null) return;
      notificationEnable = value.isNotification == 1 ? true : false;
      showMeOnMap = value.showOnMap == 1 ? true : false;
      goAnonymous = value.anonymous == 1 ? true : false;
      loginType = value.loginType;
      update();
    });
  }

  void onPrivacyPolicyTap() {
    Get.to(
      () => const WebViewScreen(
        appBarTitle: "Privacy Policy",
        url: 'privacypolicy',
      ),
    );
  }

  void onTermsOfUseTap() {
    Get.to(
      () => const WebViewScreen(
        appBarTitle: "Terms Of Use",
        url: 'termsOfUse',
      ),
    );
  }

  Future<void> onLogOutYesBtnClick() async {
    statusRequest = StatusRequest.loading;
    if (loginType == 1) {
      await googleSignOut();
    }
    if (loginType == 2) {
      // apple logout
    }
    if (loginType == 3) {
      //facebook logout
    }
    if (loginType == 4) {
      //email logout
    }
    var response = await optionDataSource.logoutUser();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      _report = Report.fromJson(response);
      await myServices.sharedPreferences.setBool('isLogin', false);
      latitude = await myServices.sharedPreferences.getString('latitude') ?? '';
      longitude =
          await myServices.sharedPreferences.getString('longitude') ?? '';
      long = double.parse(longitude);
      lat = double.parse(latitude);
      Get.snackbar('Suucess !!', "${_report!.message}",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(AppRoutes.loginScreen,
          arguments: {"long": long, "lat": lat});
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onLogoutTap() async {
    Get.dialog(
      ConfirmationDialog(
        onNoBtnClick: onNoBtnClick,
        onYesBtnClick: onLogOutYesBtnClick,
        subDescription: "Do you really want to logout from HELENY?",
        aspectRatio: 1 / 0.7,
        horizontalPadding: 70,
        clickText1: 'Yes',
        clickText2: 'No',
        heading: 'Are you sure',
      ),
    );
  }

  Future googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void onDeleteYesBtnClick() async {
    statusRequest = StatusRequest.loading;
    FirebaseAuth.instance.currentUser?.delete();
    await FirebaseAuth.instance.signOut();
    var response = await optionDataSource.deleteAccount(deleteId);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      _deleteAccount = DeleteAccount.fromJson(response);
      latitude = await myServices.sharedPreferences.getString('latitude') ?? '';
      longitude =
          await myServices.sharedPreferences.getString('longitude') ?? '';
      long = double.parse(longitude);
      lat = double.parse(latitude);
      if (_deleteAccount?.status == true) {
        await deleteFirebaseUser();
        Get.snackbar('Success !!', _deleteAccount!.message!,
            snackPosition: SnackPosition.BOTTOM);
        await myServices.sharedPreferences.setBool('isLogin', false);
        Get.offAllNamed(AppRoutes.loginScreen,
            arguments: {"long": long, "lat": lat});
      }
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  Future<void> deleteFirebaseUser() async {
    await db
        .collection('userchatlist')
        .doc(userData?.identity)
        .collection('userlist')
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection('userchatlist')
            .doc(element.id)
            .collection('userlist')
            .doc(userData?.identity)
            .update({
          'isDeleted': true,
          'deletedId': '${DateTime.now().millisecondsSinceEpoch}',
          'block': false,
          'blockFromOther': false,
        });

        db
            .collection('userchatlist')
            .doc(userData?.identity)
            .collection('userlist')
            .doc(element.id)
            .update({
          'isDeleted': true,
          'deletedId': '${DateTime.now().millisecondsSinceEpoch}',
          'block': false,
          'blockFromOther': false,
        });
      }
    });
  }

  @override
  void onNoBtnClick() {
    Get.back();
  }

  void onDeleteAccountTap() {
    Get.dialog(
      ConfirmationDialog(
        onNoBtnClick: onNoBtnClick,
        onYesBtnClick: onDeleteYesBtnClick,
        subDescription: "Do you really want to delete your account ? ",
        aspectRatio: 1 / 0.8,
        horizontalPadding: 65,
        clickText1: 'Yes',
        clickText2: 'No',
        heading: 'Are you sure',
      ),
    );
  }

  @override
  Future<void> onMoreBtnTap(String value) async {
    if (value == 'Dark') {
      Get.changeThemeMode(ThemeMode.dark);
      await myServices.sharedPreferences.setBool('theme', true);
    }
    if (value == 'Light') {
      Get.changeThemeMode(ThemeMode.light);
      await myServices.sharedPreferences.setBool('theme', false);
    }
  }
}
