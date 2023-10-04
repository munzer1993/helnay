// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/controller/home_bottomnavbar_widget_controller/home_bottomnavbar_widget_controller.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/home_bottom_nav_bar_widget/compentent/topstory_home_bottomnavbar_widget.dart';
import 'package:sizer/sizer.dart';

class ImageViewHomeBottomNavBarWidget
    extends GetView<HomeBottomNaBarWidgetControllerIMP> {
  final List<RegistrationUserData>? userData;
  final VoidCallback onLiveBtnTap;
  final VoidCallback onInstagramTap;
  final VoidCallback onFacebookTap;
  final bool isLoading;
  final VoidCallback onYoutubeTap;
  final bool Function(String? value) isSocialBtnVisible;
  const ImageViewHomeBottomNavBarWidget({
    super.key,
    required this.userData,
    required this.onFacebookTap,
    required this.isLoading,
    required this.onLiveBtnTap,
    required this.onInstagramTap,
    required this.onYoutubeTap,
    required this.isSocialBtnVisible,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeBottomNaBarWidgetControllerIMP>(
      init: HomeBottomNaBarWidgetControllerIMP(),
      builder: (controller) => Expanded(
        child: SizedBox(
          child: PageView.builder(
            itemCount: userData?.length ?? 0,
            itemBuilder: (context, index) {
              List<Images>? imagesProfile = userData?[index].images;
              final PageController pageController = PageController();
              return Stack(
                children: [
                  imagesProfile == null || imagesProfile.isEmpty
                      ? Container(
                          width: Get.width,
                          height: Get.height,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .error,
                            borderRadius: BorderRadius.circular(17.sp),
                          ),
                          child: SvgPicture.asset(
                            AppPhotoLink.noImage,
                            fit: BoxFit.fill,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(17.sp),
                            topRight: Radius.circular(17.sp),
                          ),
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: userData?[index].images?.length,
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Image.network(
                                  "${AppLink.aImageBaseUrl}${imagesProfile[index].image}",
                                  fit: BoxFit.cover,
                                  width: Get.width,
                                  height: Get.height,
                                  filterQuality: FilterQuality.medium,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .error,
                                    child: SvgPicture.asset(
                                        AppPhotoLink.noImage,
                                        width: Get.width,
                                        height: Get.height),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Lottie.asset(AppPhotoLink.loading,
                                        height: Get.height, width: Get.width);
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (index == 0) {
                                            return;
                                          }
                                          pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.linear);
                                        },
                                        child: Container(
                                          height: Get.height - 256,
                                          // color: ColorRes.transparent,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (imagesProfile.length - 1 ==
                                              index) {
                                            return;
                                          }
                                          pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.linear);
                                        },
                                        child: Container(
                                          height: Get.height - 256,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                  Column(
                    children: [
                      SizedBox(height: 3.h),
                      TopStoryLineWidget(
                        pageController: pageController,
                        images: userData?[index].images ?? [],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(left: 6.sp),
                        child: Row(
                          children: [
                            SocilaIconsWidget(
                              icon: AppPhotoLink.instegramLogo,
                              size: 15.sp,
                              onSocialIconTap: onInstagramTap,
                              isVisible: isSocialBtnVisible(
                                  userData?[index].instagram),
                            ),
                            SocilaIconsWidget(
                              icon: AppPhotoLink.facebookLogo,
                              size: 15.sp,
                              onSocialIconTap: onFacebookTap,
                              isVisible:
                                  isSocialBtnVisible(userData?[index].facebook),
                            ),
                            SocilaIconsWidget(
                              icon: AppPhotoLink.youtubeLogo,
                              size: 15.sp,
                              onSocialIconTap: onYoutubeTap,
                              isVisible:
                                  isSocialBtnVisible(userData?[index].youtube),
                            ),
                            Spacer(),
                            Visibility(
                              visible: userData?[index].isLiveNow == 1
                                  ? true
                                  : false,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.sp),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: InkWell(
                                    onTap: onLiveBtnTap,
                                    child: Container(
                                      width: 17.w,
                                      height: 15.h,
                                      padding: EdgeInsets.all(2.sp),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.sp),
                                        color: Theme.of(context)
                                            .bottomNavigationBarTheme
                                            .unselectedItemColor!
                                            .withOpacity(0.33),
                                      ),
                                      child: Row(
                                        children: [
                                          LiveLogoWidget(),
                                          Text(
                                            "Live NOW".toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ProfileDetailCard(
                        userData: userData?[index],
                        onImageTap: () {
                          controller.onImageTap(userData![index].id!, index);
                        },
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
