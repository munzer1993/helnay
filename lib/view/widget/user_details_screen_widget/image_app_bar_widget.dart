// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/controller/user_details_screen_controller/user_details_screen_controller.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/widget/home_bottom_nav_bar_widget/compentent/topstory_home_bottomnavbar_widget.dart';
import 'package:sizer/sizer.dart';

class ImageAppBarWidget extends GetView<UserDetailsScreenControllerIMP> {
  List<Images> imagesProfile;
  ImageAppBarWidget({super.key, required this.imagesProfile});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.sp),
          child: PageView.builder(
            controller: pageController,
            itemCount: imagesProfile.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.network(
                    '${AppLink.aImageBaseUrl}${imagesProfile[index].image}',
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: Get.height,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Theme.of(context).buttonTheme.colorScheme!.error,
                      child: SvgPicture.asset(AppPhotoLink.noImage,
                          width: Get.width, height: Get.height),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
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
                                duration: const Duration(milliseconds: 500),
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
                            if (imagesProfile.length - 1 == index) {
                              return;
                            }
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.linear);
                          },
                          child: Container(
                            height: Get.height - 256,
                            // color: ColorRes.transparent,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
        Column(
          children: [
            SizedBox(height: 3.h),
            TopStoryLineWidget(
              pageController: pageController,
              images: controller.users!.images ?? [],
            ),
          ],
        ),
      ],
    );
  }
}
