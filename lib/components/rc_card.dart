import 'package:flutter/material.dart';

class RCCard extends StatelessWidget {
  const RCCard({super.key, required this.cardWidget});

  final Widget cardWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, // Container background color
        borderRadius: BorderRadius.circular(
          12,
        ), // Optional: for rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color with opacity
            blurRadius: 10, // How soft the shadow should be
            spreadRadius: 2, // How much the shadow should spread
            offset: Offset(0, 5), // Shadow position (dx, dy)
          ),
        ],
      ),
      child: cardWidget,
    );
  }
}
