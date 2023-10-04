import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/on_boarding_screen_controller/on_boarding_screen_controller.dart';
import 'package:project/data/data_sorcue/on_boarding_datasorcue/on_boarding_data_sorcue.dart';
import 'package:sizer/sizer.dart';

class CustomPageViewOnBoarding extends GetView<OnBoardingContollerImp> {
  const CustomPageViewOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: (value) {
        controller.onPageChange(value);
      },
      itemCount: onBoardingList.length,
      itemBuilder: (context, index) => Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              onBoardingList[index].title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          SizedBox(height: 5.h),
          Image.asset(
            onBoardingList[index].image!,
            width: Get.width / 1.3,
            height: Get.height / 3,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 5.h),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              onBoardingList[index].body!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
