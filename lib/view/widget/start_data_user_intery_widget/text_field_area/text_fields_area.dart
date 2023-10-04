// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/view/widget/start_data_user_intery_widget/text_field_area/text_field_controller.dart';

class TextFieldsArea extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController bioController;
  final TextEditingController ageController;
  final FocusNode addressFocus;
  final FocusNode bioFocus;
  final FocusNode ageFocus;
  final String gender;
  final bool showDropdown;
  final VoidCallback onGenderTap;
  final VoidCallback onTextFieldTap;
  final Function(String value) onGenderChange;
  final String addressError;
  final String bioError;
  final String ageError;

  TextFieldsArea(
      {Key? key,
      required this.addressController,
      required this.bioController,
      required this.ageController,
      required this.addressFocus,
      required this.bioFocus,
      required this.ageFocus,
      required this.gender,
      required this.onGenderTap,
      required this.showDropdown,
      required this.onTextFieldTap,
      required this.onGenderChange,
      required this.ageError,
      required this.addressError,
      required this.bioError})
      : super(key: key);

  final TextFieldController controller = Get.put(TextFieldController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Where do you live',
                        style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(
                        text: " (Optional)",
                        style: Theme.of(context).textTheme.bodySmall)
                  ],
                ),
              ),
              SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme!.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: addressController,
                  focusNode: addressFocus,
                  onTap: onTextFieldTap,
                  onChanged: controller.onAddressChange,
                  style: Theme.of(context).textTheme.displayMedium,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText:
                        addressError == '' ? 'Enter address' : addressError,
                    hintStyle: TextStyle(
                      color: addressError == ""
                          ? Theme.of(context).buttonTheme.colorScheme!.error
                          : Theme.of(context).colorScheme.error,
                      fontSize: 14,
                      // fontFamily: FontRes.semiBold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Bio',
                            style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(
                            text: " (Optional)",
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: " (${controller.bio.value.length}/100)",
                            style: Theme.of(context).textTheme.bodyMedium)
                      ],
                    ),
                  )),
              const SizedBox(height: 6),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme!.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: bioController,
                  focusNode: bioFocus,
                  onTap: onTextFieldTap,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  maxLength: 100,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: controller.onBioChange,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.only(bottom: 10, left: 10, top: 9),
                    counterText: "",
                    hintText: bioError == '' ? 'Enter Bio' : bioError,
                    hintStyle: TextStyle(
                      color: bioError == ""
                          ? Theme.of(context).buttonTheme.colorScheme!.error
                          : Theme.of(context).colorScheme.error,
                      fontSize: 14,
                      // fontFamily: FontRes.semiBold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text('Age', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme!.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: ageController,
                  focusNode: ageFocus,
                  onChanged: controller.onAgeChange,
                  onTap: onTextFieldTap,
                  keyboardType: TextInputType.phone,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: ageError == '' ? 'Enter age' : ageError,
                    hintStyle: TextStyle(
                      color: ageError == ""
                          ? Theme.of(context).buttonTheme.colorScheme!.error
                          : Theme.of(context).colorScheme.error,
                      fontSize: 14,
                      //sfontFamily: FontRes.semiBold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Gender',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onGenderTap,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(gender,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Transform.rotate(
                                  angle: showDropdown ? 3.1 : 0,
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
                      const SizedBox(height: 110),
                    ],
                  ),
                  showDropdown
                      ? Positioned(
                          top: 45,
                          left: 0,
                          child: DropDownBox(
                            gender: gender,
                            onChange: onGenderChange,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
