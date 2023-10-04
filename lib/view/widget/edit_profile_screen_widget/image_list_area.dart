// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/models/users/register_model.dart';

class ImageListArea extends StatelessWidget {
  final List<Images>? imageList;
  final Function(int index) onImgRemove;
  final VoidCallback onAddBtnTap;

  const ImageListArea({
    Key? key,
    required this.imageList,
    required this.onImgRemove,
    required this.onAddBtnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text('photo'.toUpperCase(),
              style: Theme.of(context).textTheme.displayLarge),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: Get.width - 105,
                height: 58,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList?.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onImgRemove(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageList?[index].id != -123
                                  ? Image.network(
                                      '${AppLink.aImageBaseUrl}${imageList?[index].image}',
                                      fit: BoxFit.cover,
                                      height: 58,
                                      width: 58,
                                    )
                                  : Image.file(
                                      File(imageList![index].image!),
                                      fit: BoxFit.cover,
                                      height: 58,
                                      width: 58,
                                    ),
                            ),
                            Container(
                              height: 31,
                              width: 31,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.30),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.delete,
                                  size: 16,
                                  color: Theme.of(context)
                                      .bottomNavigationBarTheme
                                      .unselectedItemColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                //width: 130,
                height: 58,
                child: Row(
                  children: [
                    SizedBox(width: 7),
                    InkWell(
                      onTap: onAddBtnTap,
                      child: Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).buttonTheme.colorScheme!.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.add,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
