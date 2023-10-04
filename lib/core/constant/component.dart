// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, deprecated_member_use

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

String? tokenID;
int user__ID = 0;
int reverseSwipePrice = 0;
int messagePrice = 0;

///_____________________________ firebase data_______________________///

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"}";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"}";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"}";
  }
  if (diff.inDays > 0) {
    if (diff.inDays == 1) {
      return "Yesterday";
    }
    return "${diff.inDays}days";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}";
  }
  return "just now";
}

String readTimestamp(double timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp.toInt() * 1000);
  // var diff = date.difference(now);
  var time = '';
  if (now.day == date.day) {
    time = DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
    return time;
  }
  if (now.weekday > date.weekday) {
    time = DateFormat('EEEE')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
    return time;
  }
  if (now.month == date.month) {
    time = DateFormat('dd/MMM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()));
    return time;
  }
  return time;
}

class customButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const customButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(bottom: 30),
      height: 45,
      child: MaterialButton(
        onPressed: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
        textColor: Theme.of(context).textTheme.displayMedium?.color,
        child: Text(
          title,
          style: const TextStyle(letterSpacing: 0.9),
        ),
      ),
    );
  }
}

class SocilaIconsWidget extends StatelessWidget {
  final String icon;
  final double size;
  final VoidCallback onSocialIconTap;
  final bool isVisible;
  const SocilaIconsWidget({
    super.key,
    required this.icon,
    required this.size,
    required this.onSocialIconTap,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        onTap: onSocialIconTap,
        child: Container(
          height: 29,
          width: 29,
          margin: const EdgeInsets.only(right: 7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColorLight,
          ),
          child: Center(
            child: SvgPicture.asset(icon,
                height: size, width: size, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

class LiveLogoWidget extends StatelessWidget {
  const LiveLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(AppPhotoLink.liveLogo, height: 28, width: 28),
      ],
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final VoidCallback onImageTap;
  final RegistrationUserData? userData;

  const ProfileDetailCard(
      {Key? key, required this.userData, required this.onImageTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onImageTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!
                    .withOpacity(0.33),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${userData?.fullname} ',
                          style: Theme.of(context).textTheme.displayMedium,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        userData?.age != null ? '${userData?.age}' : '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 4),
                      Visibility(
                        visible: userData?.isVerified == 2 ? true : false,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 9,
                              width: 9,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            SvgPicture.asset(
                              AppPhotoLink.tickMark,
                              height: 17.5,
                              width: 18.33,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: userData?.live == null || userData!.live!.isEmpty
                        ? false
                        : true,
                    child: Row(
                      children: [
                        GradientWidget(
                          child: Icon(
                            CupertinoIcons.placemark,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(userData?.live ?? '',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.25),
                  Text(
                    userData?.bio ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradientWidget extends StatelessWidget {
  final Widget child;
  final Color? color1;
  final Color? color2;

  const GradientWidget({
    Key? key,
    required this.child,
    this.color1,
    this.color2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          transform: GradientRotation(1),
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Theme.of(context).buttonTheme.colorScheme!.inversePrimary,
            Theme.of(context).buttonTheme.colorScheme!.onInverseSurface,
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class UnicornOutlineButton extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback _callback;
  final double _radius;

  UnicornOutlineButton({
    Key? key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
    required VoidCallback onPressed,
  })  : _painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        _child = child,
        _callback = onPressed,
        _radius = radius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: Container(
            constraints: const BoxConstraints(minWidth: 142, minHeight: 51),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required this.strokeWidth,
      required this.radius,
      required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String descriptions;
  final String text;
  final IconData iconLogo;
  final VoidCallback callback;

  const CustomDialogWidget({
    super.key,
    required this.title,
    required this.descriptions,
    required this.text,
    required this.iconLogo,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      elevation: 0.0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: dialogBox(context),
    );
  }

  dialogBox(context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              left: 10.sp, top: 25.sp, right: 10.sp, bottom: 10.sp),
          margin: EdgeInsets.only(top: 20.sp),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.sp),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
                  offset: Offset(0, 10),
                  blurRadius: 10)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 2.h),
              Text(
                descriptions,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 3.h),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: callback,
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10.sp,
          right: 10.sp,
          child: CircleAvatar(
            // backgroundColor: ,
            radius: 10.sp,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.sp),
              ),
              child: Icon(iconLogo, size: 10.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatefulWidget {
  final VoidCallback onYesBtnClick;
  final VoidCallback onNoBtnClick;
  final String subDescription;
  final double aspectRatio;
  final double horizontalPadding;
  final String clickText1;
  final String clickText2;
  final String heading;

  const ConfirmationDialog(
      {Key? key,
      required this.onNoBtnClick,
      required this.onYesBtnClick,
      required this.subDescription,
      required this.aspectRatio,
      required this.horizontalPadding,
      required this.clickText1,
      required this.clickText2,
      required this.heading})
      : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Text(
                  widget.heading,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.subDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        /*  highlightColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .inversePrimary, */
                        /* splashColor: Theme.of(context)
                            .buttonTheme
                            .colorScheme!
                            .inversePrimary, */
                        onTap: widget.onNoBtnClick,
                        child: Container(
                          height: 7.h,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            widget.clickText2,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        //highlightColor: ColorRes.transparent,
                        //splashColor: ColorRes.transparent,
                        onTap: widget.onYesBtnClick,
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 7.h,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
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
                                    .inversePrimary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(widget.clickText1,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class VideoUploadDialog extends StatelessWidget {
  final VoidCallback selectAnother;
  final VoidCallback cancelBtnTap;

  const VideoUploadDialog(
      {Key? key, required this.cancelBtnTap, required this.selectAnother})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: AspectRatio(
          aspectRatio: 0.9,
          child: Column(
            children: [
              const Spacer(flex: 2),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Too Large',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: ' Video?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Image(
                image: AssetImage(AppPhotoLink.logoHelnay),
                width: 100,
              ),
              const Spacer(
                flex: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'This video is greater than 50 mb\nPlease select another...',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              InkWell(
                //highlightColor: ColorRes.transparent,
                //splashColor: ColorRes.transparent,
                onTap: selectAnother,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
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
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    'Select another',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                //highlightColor: ColorRes.transparent,
                //splashColor: ColorRes.transparent,
                onTap: cancelBtnTap,
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReverseSwipeDialog extends StatefulWidget {
  final Function(bool isSelected) onContinueTap;
  final VoidCallback onCancelTap;
  final int? walletCoin;
  final String title1;
  final String title2;
  final String dialogDisc;
  final String coinPrice;
  final bool isCheckBoxVisible;

  const ReverseSwipeDialog(
      {Key? key,
      required this.onCancelTap,
      required this.onContinueTap,
      required this.walletCoin,
      required this.title1,
      required this.title2,
      required this.dialogDisc,
      required this.coinPrice,
      required this.isCheckBoxVisible})
      : super(key: key);

  @override
  State<ReverseSwipeDialog> createState() => _ReverseSwipeDialogState();
}

class _ReverseSwipeDialogState extends State<ReverseSwipeDialog> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Dialog(
        //backgroundColor: ColorRes.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 60),
        child: AspectRatio(
          aspectRatio: 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.title1,
                          style: Theme.of(context).textTheme.bodyMedium),
                      TextSpan(
                          text: " ${widget.title2}",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppPhotoLink.diamond,
                        height: 30, width: 30),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(widget.coinPrice,
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: Get.width / 2,
                  child: Text(
                    widget.dialogDisc,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  color: Theme.of(context).buttonTheme.colorScheme!.error,
                  height: 50,
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'wallet'.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineLarge),
                        TextSpan(
                            text: " : ${widget.walletCoin}",
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Visibility(
                  visible: widget.isCheckBoxVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          isSelected = !isSelected;
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: !isSelected
                                ? Border.all(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .inversePrimary,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(5),
                            gradient: isSelected
                                ? LinearGradient(
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
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isSelected ? Icons.check : null,
                            color: Theme.of(context).primaryColorDark,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('"use automatically from next"',
                          style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.onContinueTap(isSelected);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
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
                        )),
                    child: Text('Continue',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onCancelTap,
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownBox extends StatelessWidget {
  final String gender;
  final Function(String value) onChange;

  const DropDownBox({
    Key? key,
    required this.gender,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      //width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      //margin: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .buttonTheme
                  .colorScheme!
                  .error
                  .withOpacity(0.35),
              offset: Offset(0, 2),
              blurRadius: 3,
            ),
            BoxShadow(
              color: Theme.of(context)
                  .buttonTheme
                  .colorScheme!
                  .error
                  .withOpacity(0.35),
              offset: Offset(2, 0),
              blurRadius: 3,
            ),
          ]),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  onChange('Male');
                },
                child: Container(
                  height: 30,
                  width: Get.width - 80,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Male',
                    style: TextStyle(
                      color: gender == 'Male'
                          ? Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .inversePrimary
                          : Theme.of(context).buttonTheme.colorScheme!.error,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  onChange('Female');
                },
                child: Container(
                  height: 30,
                  width: Get.width - 80,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Female',
                    style: TextStyle(
                        color: gender == 'Female'
                            ? Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .inversePrimary
                            : Theme.of(context).buttonTheme.colorScheme!.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubmitButton2 extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SubmitButton2({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}

class EulaSheet extends StatelessWidget {
  final VoidCallback eulaAcceptClick;

  const EulaSheet({Key? key, required this.eulaAcceptClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };

    UniqueKey key = UniqueKey();
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 50 * 2),
            child: WebView(
              key: key,
              initialUrl:
                  'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
              javascriptMode: JavascriptMode.unrestricted,
              gestureRecognizers: gestureRecognizers,
            ),
          ),
          SafeArea(
            top: false,
            child: TextButton(
              onPressed: eulaAcceptClick,
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme!.onInverseSurface,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child:
                  Text('Accept', style: Theme.of(context).textTheme.bodyLarge),
            ),
          )
        ],
      ),
    );
  }
}
