import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/data/models/notification_widget_model/admin_notification_model.dart';

class AdminNotificationPage extends StatelessWidget {
  final List<AdminNotificationData>? adminNotification;
  final ScrollController controller;

  const AdminNotificationPage(
      {Key? key, this.adminNotification, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return adminNotification == null || adminNotification!.isEmpty
        ? Center(
            child: LottieBuilder.asset(
              AppPhotoLink.emptyListLottie,
              height: 200,
              width: 200,
            ),
          )
        : ListView.builder(
            controller: controller,
            padding: const EdgeInsets.only(top: 15),
            itemCount: adminNotification?.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 16, right: 19, bottom: 18),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .inversePrimary,
                            Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .onInverseSurface,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    SizedBox(
                      width: Get.width - 94,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${adminNotification?[index].title}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const Spacer(),
                              Text(
                                  adminNotification != null
                                      ? timeAgo(DateTime.parse(
                                          '${adminNotification?[index].createdAt}'))
                                      : '',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                          Text('${adminNotification?[index].message}',
                              style: Theme.of(context).textTheme.bodyMedium)
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
