import 'package:flutter/material.dart';

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> BuildSnackBar(
      BuildContext context, String msg, Color bgColor, Color textColor) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg,style: Theme.of(context).textTheme.bodyText1?.copyWith(color: textColor)),backgroundColor: bgColor,));
}