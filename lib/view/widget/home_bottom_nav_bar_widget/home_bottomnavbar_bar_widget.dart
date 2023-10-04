// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/home_bottomnavbar_widget_controller/home_bottomnavbar_widget_controller.dart';
import 'package:project/view/widget/home_bottom_nav_bar_widget/compentent/image_page_view_builder.dart';

class HomeBottomNaBarWidget extends StatelessWidget {
  const HomeBottomNaBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeBottomNaBarWidgetControllerIMP>(
      init: HomeBottomNaBarWidgetControllerIMP(),
      builder: (controller) => Column(
        children: [
          ImageViewHomeBottomNavBarWidget(
            userData: controller.user_data,
            onFacebookTap: controller.onFBTap,
            onInstagramTap: controller.onInstagramTap,
            onLiveBtnTap: controller.onLiveBtnTap,
            onYoutubeTap: controller.onYoutubeTap,
            isLoading: controller.isLoading,
            isSocialBtnVisible: controller.isSocialBtnVisible,
          ),
        ],
      ),
    );
  }
}
