// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:project/controller/edit_profile_screen_controller/edit_profile_screen_controller.dart';

class InterestList extends StatelessWidget {
  final EditProfileScreenControllerIMP model;

  const InterestList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interest', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.center,
          children: model.hobbiesList!.map<Widget>((e) {
            bool selected = model.selectedList.contains(e.id.toString());
            return InkWell(
              onTap: () {
                model.onClipTap(e.id.toString());
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: selected
                      ? LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        )
                      : LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.onError,
                            Theme.of(context).colorScheme.onError,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  "${e.title}",
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColorLight,
                    fontSize: 14,
                    // fontFamily: FontRes.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
