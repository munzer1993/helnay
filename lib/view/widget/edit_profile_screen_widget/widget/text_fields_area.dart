// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/edit_profile_screen_controller/edit_profile_screen_controller.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/view/widget/edit_profile_screen_widget/interest_list.dart';
import 'package:project/view/widget/edit_profile_screen_widget/widget/text_field_controller.dart';
import 'package:sizer/sizer.dart';

class TextFieldsArea extends StatelessWidget {
  final EditProfileScreenControllerIMP model;

  TextFieldsArea({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ProfileTextFieldController controller =
      Get.put(ProfileTextFieldController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text('full Name'.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          _textField(
            controller: model.fullNameController,
            error: model.fullNameError,
            hint: 'Enter FullName',
            focusNode: model.fullNameFocus,
            context: context,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Obx(
              () => RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Bio',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                        text: " (Optional)",
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                        text: " (${controller.bio.value.length}/100)",
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .buttonTheme
                  .colorScheme!
                  .error
                  .withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: model.bioController,
              focusNode: model.bioFocus,
              onTap: model.onAllScreenTap,
              maxLines: null,
              minLines: null,
              expands: true,
              textInputAction: TextInputAction.next,
              maxLength: 100,
              onChanged: controller.onBioChange,
              style: Theme.of(context).textTheme.bodyMedium,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: model.bioError == '' ? 'Enter Bio' : model.bioError,
                hintStyle: TextStyle(
                  color: model.bioError == ""
                      ? Theme.of(context).buttonTheme.colorScheme!.error
                      : Theme.of(context)
                          .buttonTheme
                          .colorScheme!
                          .inversePrimary,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.only(bottom: 10, left: 10, top: 9),
                counterText: "",
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Obx(
              () => RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'About',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                        text: " (${controller.about.value.length}/300)",
                        style: Theme.of(context).textTheme.bodyMedium)
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .buttonTheme
                  .colorScheme!
                  .error
                  .withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: model.aboutController,
              focusNode: model.aboutFocus,
              onTap: model.onAllScreenTap,
              textInputAction: TextInputAction.next,
              maxLines: null,
              minLines: null,
              expands: true,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 300,
              onChanged: controller.onAboutChange,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    model.aboutError == '' ? 'Enter About' : model.aboutError,
                hintStyle: TextStyle(
                  color: model.aboutError == ""
                      ? Theme.of(context).buttonTheme.colorScheme!.error
                      : Theme.of(context)
                          .buttonTheme
                          .colorScheme!
                          .inversePrimary,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.only(bottom: 10, left: 10, top: 9),
                counterText: "",
              ),
            ),
          ),
          const SizedBox(height: 10),
          _textView(
            title: 'Where Do You Live',
            optional: ' (${'Optional'})',
            context: context,
          ),
          _textField(
            controller: model.addressController,
            focusNode: model.addressFocus,
            error: model.addressError,
            hint: 'Enter Address',
            context: context,
          ),
          const SizedBox(height: 10),
          _textView(title: 'Age', optional: '', context: context),
          _textField(
              controller: model.ageController,
              focusNode: model.ageFocus,
              error: model.ageError,
              hint: 'Enter Age',
              context: context,
              keyBoardType: TextInputType.phone),
          const SizedBox(height: 10),
          _textView(title: 'Gender', optional: '', context: context),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: model.onGenderTap,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonTheme.colorScheme!.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.gender,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Transform.rotate(
                              angle: model.showDropdown ? 3.1 : 0,
                              child: Icon(
                                CupertinoIcons.chevron_down,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _textView(
                    title: 'instagram'.toUpperCase(),
                    optional: '',
                    context: context,
                  ),
                  socialLinkTextField(
                    controller: model.instagramController,
                    focusNode: model.instagramFocus,
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  _textView(
                    title: 'facebook'.toUpperCase(),
                    optional: '',
                    context: context,
                  ),
                  socialLinkTextField(
                    controller: model.facebookController,
                    focusNode: model.facebookFocus,
                    context: context,
                  ),
                  const SizedBox(height: 10),
                  _textView(
                      title: 'youtube'.toUpperCase(),
                      optional: '',
                      context: context),
                  socialLinkTextField(
                    controller: model.youtubeController,
                    focusNode: model.youtubeFocus,
                    context: context,
                  ),
                ],
              ),
              model.showDropdown
                  ? Positioned(
                      top: 45,
                      child: DropDownBox(
                        gender: model.gender,
                        onChange: model.onGenderChange,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 15),
          InterestList(model: model),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: model.onSaveTap,
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child:
                    Text('Save', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ),
          const SizedBox(height: 47),
        ],
      ),
    );
  }

  Widget _textView(
      {required String title,
      required String optional,
      required BuildContext context}) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: title, style: Theme.of(context).textTheme.bodyMedium),
              TextSpan(
                  text: optional, style: Theme.of(context).textTheme.bodyMedium)
            ],
          ),
        ));
  }

  Widget socialLinkTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required BuildContext context,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color:
            Theme.of(context).buttonTheme.colorScheme!.error.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: model.onAllScreenTap,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(bottom: 10, left: 10),
        ),
      ),
    );
  }

  Widget _textField(
      {required TextEditingController controller,
      required String error,
      required FocusNode focusNode,
      required String hint,
      required BuildContext context,
      TextInputType? keyBoardType}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color:
            Theme.of(context).buttonTheme.colorScheme!.error.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyBoardType,
        textCapitalization: TextCapitalization.sentences,
        onTap: model.onAllScreenTap,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: error == '' ? hint : error,
          hintStyle: TextStyle(
            color: error == ""
                ? Theme.of(context).buttonTheme.colorScheme!.error
                : Theme.of(context).buttonTheme.colorScheme!.onInverseSurface,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
        ),
      ),
    );
  }
}
