import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class RCIconWidget extends StatelessWidget {
  Widget iconImage;
  Gender gender;

  RCIconWidget({required this.iconImage, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: gender.color, // The fill color of the circle
        shape: BoxShape.circle, // Makes the container circular
        border: Border.all(
          color: Colors.white, // Color of the circular border
          width: 2.0, // Width of the border
        ),
        boxShadow: [
          // Optional: adds a shadow
          BoxShadow(color: Colors.black38, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      // Replace with your asset image or NetworkImage
      child: Center(child: iconImage),
    );
  }
}
