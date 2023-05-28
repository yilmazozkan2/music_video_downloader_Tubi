import 'package:flutter/material.dart';

import '../../constants/padding.dart';

class DownloadContainer extends StatelessWidget {
  DownloadContainer({
    super.key,
    required this.text,
  });
  String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: ProjectDecorations.onlyTopPadding,
      width: MediaQuery.of(context).size.width,
      padding: ProjectDecorations.allPadding,
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
