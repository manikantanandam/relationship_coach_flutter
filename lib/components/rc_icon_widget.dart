import 'package:flutter/material.dart';

class RCIconWidget extends StatelessWidget {
  Widget iconImage;

  RCIconWidget({required this.iconImage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center, // Centers the children within the stack
        children: <Widget>[
          // Background/Bottom Image
          Container(
            width: 40,
            height: 40,
            // Replace with your asset image or NetworkImage
            child: Image.asset(
              'lib/assets/ic_icon_background_female.png',
              fit: BoxFit.cover,
            ),
          ),
          iconImage,
        ],
      ),
    );
  }
}
