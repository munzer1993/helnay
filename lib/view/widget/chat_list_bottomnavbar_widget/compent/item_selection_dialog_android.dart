// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ItemSelectionDialogAndroid extends StatelessWidget {
  final VoidCallback onImageBtnClick;
  final VoidCallback onVideoBtnClick;
  final VoidCallback onCloseBtnClick;

  const ItemSelectionDialogAndroid(
      {Key? key,
      required this.onCloseBtnClick,
      required this.onImageBtnClick,
      required this.onVideoBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 13),
            child: Text(
              "Which item would you like to select?\nSelect a item",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          Expanded(
            child: InkWell(
              onTap: onImageBtnClick,
              child: Center(
                child: Text(
                  'Photos',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: InkWell(
              onTap: onVideoBtnClick,
              child: Center(
                child: Text('Videos',
                    style: Theme.of(context).textTheme.displayMedium),
              ),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: onCloseBtnClick,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
