import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/data/data_sorcue/notification_widget_datasource/notification_widget_datasource.dart';
import 'package:project/data/models/notification_widget_model/admin_notification_model.dart';
import 'package:project/data/models/notification_widget_model/user_notification_model.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class NotificationBottomNavBarWidgetController extends GetxController {
  void getAdminNotificationApiCall();
  void fetchScrollData();
  void getUserNotificationApiCall();
  void onUserTap(RegistrationUserData? data);
  void onTabChange(int index);
  void onBack();
}

class NotificationBottomNavBarWidgetControllerIMP
    extends NotificationBottomNavBarWidgetController {
  String notification = 'Notification';
  int tabIndex = 0;
  int start = 0;
  int adminStart = 0;
  late ScrollController userScrollController = ScrollController();
  ScrollController adminScrollController = ScrollController();
  bool isLoading = false;
  UserNotification? userNotificationModel;
  AdminNotification? adminNotificationModel;
  List<AdminNotificationData>? adminNotification = [];
  List<UserNotificationData>? userNotification = [];
  NotificationDataSource notificationDataSource =
      NotificationDataSource(Get.find());
  StatusRequest? statusRequest;

  @override
  void onInit() {
    getUserNotificationApiCall();
    fetchScrollData();
    super.onInit();
  }

  @override
  void dispose() {
    userScrollController.dispose();
    adminScrollController.dispose();
    super.dispose();
  }

  @override
  void getAdminNotificationApiCall() async {
    statusRequest = StatusRequest.loading;
    var response = await notificationDataSource.adminNotifiation(adminStart);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      adminNotificationModel = AdminNotification.fromJson(response);
      update();
      if (adminStart == 0) {
        adminNotification = adminNotificationModel!.data;
      } else {
        adminNotification?.addAll(adminNotificationModel!.data!);
      }
      adminStart = adminNotification!.length;
      isLoading = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void fetchScrollData() {
    if (adminScrollController.hasClients) {
      adminScrollController.addListener(
        () {
          if (adminScrollController.offset ==
              adminScrollController.position.maxScrollExtent) {
            if (!isLoading) {
              getAdminNotificationApiCall();
            }
          }
        },
      );
    }
    if (userScrollController.hasClients) {
      userScrollController.addListener(
        () {
          if (adminScrollController.offset ==
              adminScrollController.position.maxScrollExtent) {
            if (!isLoading) {
              getUserNotificationApiCall();
            }
          }
        },
      );
    }
  }

  @override
  void getUserNotificationApiCall() async {
    isLoading = true;
    statusRequest = StatusRequest.loading;
    var response = await notificationDataSource.getUserNotification(start);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      userNotificationModel = UserNotification.fromJson(response);
      update();
      if (start == 0) {
        userNotification = userNotificationModel!.data;
      } else {
        userNotification?.addAll(userNotificationModel!.data!);
      }
      start = userNotification!.length;
      isLoading = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onUserTap(RegistrationUserData? data) {
    Get.toNamed(AppRoutes.userDetailsScreen, arguments: data);
  }

  @override
  void onBack() {
    Get.back();
  }

  @override
  void onTabChange(int index) {
    tabIndex = index;
    tabIndex == 0
        ? getUserNotificationApiCall()
        : getAdminNotificationApiCall();
    update();
  }
}
