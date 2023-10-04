import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/user_details_screen_controller/user_details_screen_controller.dart';
import 'package:project/core/constant/component.dart';

class LikeUnlikeBtnWidget extends StatelessWidget {
  final VoidCallback onLikeBtnTap;
  final bool like;
  final int? userId;
  const LikeUnlikeBtnWidget(
      {super.key, required this.onLikeBtnTap, required this.like, this.userId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailsScreenControllerIMP>(
      init: UserDetailsScreenControllerIMP(),
      builder: (controller) => Visibility(
        visible: user__ID == userId ? false : true,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            onLikeBtnTap();
            controller.controllerAnimation
                .reverse()
                .then((value) => controller.controllerAnimation.forward());
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.30),
            ),
            child: Center(
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorLight.withOpacity(0.60),
                ),
                child: like
                    ? ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(
                            CurvedAnimation(
                                parent: controller.controllerAnimation,
                                curve: Curves.easeOut)),
                        child: GradientWidget(
                          child: Icon(
                            CupertinoIcons.heart_solid,
                            color: Theme.of(context).primaryColorLight,
                            size: 30,
                          ),
                        ),
                      )
                    : ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(
                            CurvedAnimation(
                                parent: controller.controllerAnimation,
                                curve: Curves.easeOut)),
                        child: Icon(
                          CupertinoIcons.heart_solid,
                          color: Theme.of(context).primaryColorLight,
                          size: 30,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
