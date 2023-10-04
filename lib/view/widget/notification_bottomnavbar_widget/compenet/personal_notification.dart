import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/models/notification_widget_model/user_notification_model.dart';
import 'package:project/data/models/users/register_model.dart';

class PersonalNotificationPage extends StatelessWidget {
  final List<UserNotificationData>? userNotification;
  final ScrollController controller;
  final Function(RegistrationUserData? data) onUserTap;

  const PersonalNotificationPage(
      {Key? key,
      this.userNotification,
      required this.controller,
      required this.onUserTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userNotification == null || userNotification!.isEmpty
        ? Center(
            child: LottieBuilder.asset(
              AppPhotoLink.emptyListLottie,
              height: Get.height - 100,
              width: Get.width - 100,
            ),
          )
        : ListView.builder(
            controller: controller,
            padding: const EdgeInsets.only(top: 15),
            itemCount: userNotification?.length,
            itemBuilder: (context, index) {
              RegistrationUserData? data = userNotification?[index].dataUser;
              return InkWell(
                onTap: () {
                  onUserTap(data);
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 19, bottom: 18),
                  child: Row(
                    children: [
                      data?.images == null || data!.images!.isEmpty
                          ? Container(
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
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                '${AppLink.aImageBaseUrl}${data.images?[0].image}',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppPhotoLink.logoHelnay,
                                    width: 40,
                                    height: 40,
                                  );
                                },
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
                                Text('${data?.fullname}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Text(' ${data?.age}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(
                                  width: 4,
                                ),
                                Visibility(
                                  visible: data?.isVerified == 2 ? true : false,
                                  child: SvgPicture.asset(
                                    AppPhotoLink.tickMark,
                                    height: 14.87,
                                    width: 15.58,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                    userNotification != null
                                        ? timeAgo(
                                            DateTime.parse(
                                                '${userNotification?[index].createdAt}'),
                                          )
                                        : '',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                            Text(
                              userNotification?[index].type == 1
                                  ? '${data?.fullname} has liked your profile, you should check their profile!'
                                  : '',
                              style: Theme.of(context).textTheme.displayMedium,
                              maxLines: 2,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
