
import 'package:flutter/material.dart';

import '../../constants/padding.dart';

class VideoDownloadContainer extends StatelessWidget {
  const VideoDownloadContainer ({super.key});

  @override
  Widget build(BuildContext context) {
     return Container(
                color: Colors.red,
                margin: ProjectDecorations.onlyTopPadding,
                width: MediaQuery.of(context).size.width,
                padding: ProjectDecorations.allPadding,
                alignment: Alignment.center,
                child: Text(
                  "720p Download",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              );
  }
}