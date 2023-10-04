// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project/controller/on_boarding_screen_controller/on_boarding_screen_controller.dart';

class CustomButtonOnBoarding extends GetView<OnBoardingContollerImp> {
  const CustomButtonOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(bottom: 30),
      height: 45,
      child: MaterialButton(
        onPressed: () {
          controller.next();
        },
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
        textColor: Theme.of(context).textTheme.displayMedium?.color,
        child: Text(
          'Continue'.toUpperCase(),
          style: const TextStyle(letterSpacing: 0.9),
        ),
      ),
    );
  }
}
