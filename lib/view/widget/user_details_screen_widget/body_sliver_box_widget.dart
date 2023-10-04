// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/user_details_screen_widget/like_unlike_btn.dart';
import 'package:sizer/sizer.dart';

class BodySilverBoxWidget extends StatelessWidget {
  final RegistrationUserData? userData;
  final VoidCallback onChatWithTap;
  final double distance;
  final VoidCallback onShareWithTap;
  final VoidCallback onReportTap;
  final bool like;
  final int? userId;
  final VoidCallback onLikeBtnTap;
  const BodySilverBoxWidget({
    super.key,
    required this.userData,
    required this.userId,
    required this.onChatWithTap,
    required this.distance,
    required this.onLikeBtnTap,
    required this.like,
    required this.onReportTap,
    required this.onShareWithTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: ClipRRect(
            child: Container(
              padding: EdgeInsets.fromLTRB(21, 20, 21, 0),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!
                    .withOpacity(0.33),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "PROFILE",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        LikeUnlikeBtnWidget(
                          like: like,
                          onLikeBtnTap: onLikeBtnTap,
                          userId: userId,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(userData?.bio ?? 'No BIO',
                        style: Theme.of(context).textTheme.displayMedium),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.30),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: const EdgeInsets.only(top: 3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .primaryColorLight
                                          .withOpacity(0.30),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.home,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: Text(
                                    userData?.live == null ||
                                            userData!.live!.isEmpty
                                        ? ''
                                        : '${userData?.live}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Visibility(
                            visible: user__ID == userData?.id ? false : true,
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.30),
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: const EdgeInsets.only(top: 3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.30),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.placemark,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Flexible(
                                  child: Text(
                                    distance == 0.0
                                        ? "No Location"
                                        : '${distance.toStringAsFixed(2)}KMS Away',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text("ABOUT",
                        style: Theme.of(context).textTheme.displayLarge),
                    SizedBox(height: 2.h),
                    Text(userData?.about ?? '',
                        style: Theme.of(context).textTheme.displayMedium),
                    SizedBox(height: 8.h),
                    Text("interest".toUpperCase(),
                        style: Theme.of(context).textTheme.displayLarge),
                    SizedBox(height: 6.h),
                    interestButtons(userData?.interests ?? [], context),
                    SizedBox(height: 1.h),
                    Visibility(
                      visible: user__ID == userData?.id ? false : true,
                      child: InkWell(
                        onTap: onChatWithTap,
                        borderRadius: BorderRadius.circular(5.sp),
                        child: Container(
                          height: 8.h,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(5.sp),
                          ),
                          child: Center(
                            child: Text(
                                'CHAT WITH ${userData?.fullname?.toUpperCase()}',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    /* InkWell(
                      onTap: onShareWithTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .error
                              .withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'SHARE ${userData?.fullname?.toUpperCase()}\'S PROFILE',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ), */
                    SizedBox(height: 2.h),
                    Visibility(
                      visible: user__ID == userData?.id ? false : true,
                      child: Center(
                        child: InkWell(
                          onTap: onReportTap,
                          child: Text(
                              'REPORT ${userData?.fullname?.toUpperCase()}',
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget interestButtons(List<Interest> interests, context) {
    return Wrap(
      children: interests.map<Widget>((e) {
        return Container(
          margin: const EdgeInsets.only(right: 8, bottom: 10),
          padding: const EdgeInsets.fromLTRB(20.6, 9.50, 20.6, 8.51),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight.withOpacity(0.15),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text('${e.title?.toUpperCase()}',
              style: Theme.of(context).textTheme.bodyMedium),
        );
      }).toList(),
    );
  }
}
