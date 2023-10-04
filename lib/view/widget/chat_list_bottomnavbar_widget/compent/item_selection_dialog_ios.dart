// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemSelectionDialogIos extends StatelessWidget {
  final VoidCallback onImageBtnClickIos;
  final VoidCallback onVideoBtnClickIos;
  final VoidCallback onCloseBtnClickIos;

  const ItemSelectionDialogIos(
      {Key? key,
      required this.onCloseBtnClickIos,
      required this.onImageBtnClickIos,
      required this.onVideoBtnClickIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        "Which item would you like to select?\nSelect a item",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: onImageBtnClickIos,
          child: Text('Photos'),
        ),
        CupertinoActionSheetAction(
          onPressed: onVideoBtnClickIos,
          child: Text('Videos'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: onCloseBtnClickIos,
        child: Text('Close'),
      ),
    );
  }
}
