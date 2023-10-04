// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/user_details_screen_controller/user_details_screen_controller.dart';
import 'package:project/view/widget/user_details_screen_widget/body_sliver_box_widget.dart';
import 'package:project/view/widget/user_details_screen_widget/image_app_bar_widget.dart';
import 'package:project/view/widget/user_details_screen_widget/top_bar_name_widget.dart';
import 'package:sizer/sizer.dart';

class CustomScreollViewWidget extends GetView<UserDetailsScreenControllerIMP> {
  const CustomScreollViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            onPressed: controller.goBack,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 16.sp,
              color: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: TopBarWidget(
              fullName: controller.users?.fullname ?? '',
              age: controller.users!.age.toString(),
            ),
          ),
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          expandedHeight: 50.h,
          flexibleSpace: FlexibleSpaceBar(
            background: ImageAppBarWidget(
              imagesProfile: controller.users?.images ?? [],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BodySilverBoxWidget(
            userData: controller.users,
            onChatWithTap: controller.onChatWithBtnTap,
            distance: controller.distance,
            onReportTap: controller.onReportTap,
            onShareWithTap: controller.onShareProfileBtnTap,
            like: controller.like,
            onLikeBtnTap: controller.onLikeBtnTap,
            userId: controller.userId,
          ),
        ),
      ],
    );
  }
}
