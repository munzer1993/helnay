// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/controller/notification_bottomnavbar_widget_controller/notification_bottomnavbar_widget_controller.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/view/widget/notification_bottomnavbar_widget/compenet/admin_notificaiton_page.dart';
import 'package:project/view/widget/notification_bottomnavbar_widget/compenet/personal_notification.dart';

class NotificationBottomNavBarWidget extends StatelessWidget {
  const NotificationBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<NotificationBottomNavBarWidgetControllerIMP>(
        init: NotificationBottomNavBarWidgetControllerIMP(),
        builder: (model) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              height: 1,
              width: Get.width,
              color: Theme.of(context).buttonTheme.colorScheme!.error,
            ),
            const SizedBox(height: 11),
            Container(
              height: 50,
              width: Get.width,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(
                  left: 40, right: 40, top: 30, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => model.onTabChange(0),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        width: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: model.tabIndex == 0
                              ? Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .inversePrimary
                              : Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .background,
                        ),
                        child: Center(
                          child: Text(
                            'Personal',
                            style: TextStyle(
                              color: model.tabIndex == 0
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onBackground,
                              //fontFamily: FontRes.regular,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => model.onTabChange(1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        width: 112,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: model.tabIndex == 1
                              ? Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .inversePrimary
                              : Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .background,
                        ),
                        child: Center(
                          child: Text(
                            'Platform',
                            style: TextStyle(
                              color: model.tabIndex == 1
                                  ? Theme.of(context).primaryColorDark
                                  : Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .onBackground,
                              //fontFamily: FontRes.regular,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            model.isLoading
                ? Expanded(
                    child: Center(
                        child: Lottie.asset(AppPhotoLink.loading,
                            width: 300, height: 300)),
                  )
                : Expanded(
                    child: model.tabIndex == 0
                        ? PersonalNotificationPage(
                            userNotification: model.userNotification,
                            controller: model.userScrollController,
                            onUserTap: model.onUserTap,
                          )
                        : AdminNotificationPage(
                            adminNotification: model.adminNotification,
                            controller: model.adminScrollController,
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
