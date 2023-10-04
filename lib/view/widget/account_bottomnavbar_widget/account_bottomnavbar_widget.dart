// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/account_profile_screen_controller/acount_profile_screen_controller.dart';
import 'package:project/view/widget/account_bottomnavbar_widget/compenent/profile_images_area.dart';

class AccountBottomNavBarWidget extends StatelessWidget {
  const AccountBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountProfileScreenControllerIMP>(
      init: AccountProfileScreenControllerIMP(),
      builder: (controller) => Column(
        children: [
          ProfileImageArea(
            userData: controller.userData,
            pageController: controller.pageController,
            onEditProfileTap: controller.onEditProfileTap,
            onMoreBtnTap: controller.onMoreBtnTap,
            onImageTap: controller.onImageTap,
            onInstagramTap: controller.onInstagramTap,
            onFacebookTap: controller.onFBTap,
            onYoutubeTap: controller.onYoutubeTap,
            isLoading: controller.isLoading,
            isVerified: controller.userData?.isVerified == 2 ? true : false,
            isSocialBtnVisible: controller.isSocialBtnVisible,
          ),
        ],
      ),
    );
  }
}
