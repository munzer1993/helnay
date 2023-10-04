// ignore_for_file: prefer_const_constructors

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/data/data_sorcue/report_datasource/report_datasource.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/report_model/report_model.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/web_view_widget/web_view_widget.dart';

abstract class ReportSheetViewController extends GetxController {
  void onBackBtnTap();
  void onCheckBoxChange(bool? value);
  void onReasonTap();
  void onReasonChange(String value);
  void onSubmitBtnTap();
}

class ReportSheetViewControllerIMP extends ReportSheetViewController {
  String fullName = '';
  String city = '';
  String userImage = '';
  String age = '';
  StatusRequest? statusRequest;
  Conversation? conversation;
  ReportDataSource reportDataSource = ReportDataSource(Get.find());
  Report? report;
  bool showDropdown = false;
  bool? isCheckBox = false;
  String reason = 'Cyberbullying';
  String explainMoreError = '';
  TextEditingController explainMoreController = TextEditingController();
  FocusNode explainFocusNode = FocusNode();
  TextEditingController explainController = TextEditingController();
  FocusNode explainMoreFocus = FocusNode();
  bool isExplainError = false;
  List<String> reasonList = [
    'Cyberbullying',
    'Harassment',
    'Personal Harassment',
    'Inappropriate Content'
  ];

  bool isShowDown = false;
  RegistrationUserData? registrationUserData;

  @override
  void onInit() {
    registrationUserData = Get.arguments;
    super.onInit();
  }

  @override
  void onCheckBoxChange(bool? value) {
    isCheckBox = value;
    explainMoreFocus.unfocus();
    update();
  }

  @override
  void onReasonTap() {
    isShowDown = !isShowDown;
    explainMoreFocus.unfocus();
    update();
  }

  void onAllScreenTap() {
    isShowDown = false;
    update();
  }

  void onTermAndConditionClick() {
    Get.to(() => WebViewScreen(
          appBarTitle: '"Terms Of Use"',
          url: 'termsOfUse',
        ));
  }

  bool isValid() {
    int i = 0;
    explainMoreFocus.unfocus();
    isExplainError = false;

    if (explainController.text == '') {
      isExplainError = true;
      explainMoreError = 'Enter Full Reason';
      i++;
      return false;
    }
    if (isCheckBox == false) {
      Get.rawSnackbar(
        message: 'Please Check Term',
        backgroundColor: Colors.black,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 2),
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        dismissDirection: DismissDirection.horizontal,
      );
      i++;
    }
    update();
    return i == 0 ? true : false;
  }

  @override
  void onSubmitBtnTap() async {
    bool validation = isValid();
    statusRequest = StatusRequest.loading;
    update();
    if (validation) {
      var response = await reportDataSource.addReport(
          reason, explainController.text, conversation?.user?.userid);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        statusRequest = StatusRequest.success;
        report = Report.fromJson(response);
        Get.snackbar("ERRPR !!", report!.message!,
            snackPosition: SnackPosition.BOTTOM);
        Get.back();
      } else {
        statusRequest = StatusRequest.failure;
        update();
      }
    }
  }

  void onBackBtnClick() {
    Get.back();
  }

  @override
  void onReasonChange(String value) {
    reason = value;
    isShowDown = !isShowDown;
    update();
  }

  @override
  void onBackBtnTap() {
    Get.back();
  }
}
