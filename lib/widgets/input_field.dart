import 'package:flutter/material.dart';

import '../constants/padding.dart';

class InputField extends StatelessWidget {
  
  InputField({super.key, required this.textController,});
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectDecorations.symetricPadding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.red,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
              controller: textController,
            ),
          ),
        ],
      ),
    );
  }
}