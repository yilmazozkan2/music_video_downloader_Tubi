
import 'package:flutter/material.dart';

import '../../constants/padding.dart';

class Quality18DownloadContainer extends StatelessWidget {
  const Quality18DownloadContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                color: Colors.red,
                margin: ProjectDecorations.onlyTopPadding,
                width: MediaQuery.of(context).size.width,
                padding: ProjectDecorations.allPadding,
                alignment: Alignment.center,
                child: Text(
                  "360p Download",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color:Colors.white),
                ),
              );
  }
}