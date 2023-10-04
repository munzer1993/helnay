import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ReportScreenController extends GetxController {
  void onCheckBoxChange(bool? value);
  void onReasonTap();
  void onBackBtnClick();
  void onReasonChange(String value);
}

class ReportScreenControllerIMP extends ReportScreenController {
  String fullName = '';
  String city = '';
  String userImage = '';
  String age = '';

  TextEditingController explainController = TextEditingController();
  FocusNode explainMoreFocus = FocusNode();
  String explainMoreError = '';
  String reason = 'Cyberbullying';
  List<String> reasonList = [
    'Cyberbullying',
    'Harassment',
    'Personal Harassment',
    'Inappropriate Content'
  ];
  bool? isCheckBox = false;
  bool isShowDown = false;

  @override
  void onInit() {
    fullName = Get.arguments['reportName'];
    city = Get.arguments['reportAddress'];
    userImage = Get.arguments['reportImage'];
    age = Get.arguments['reportAge'];
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

  @override
  void onBackBtnClick() {
    Get.back();
  }

  @override
  void onReasonChange(String value) {
    reason = value;
    isShowDown = !isShowDown;
    update();
  }
}
