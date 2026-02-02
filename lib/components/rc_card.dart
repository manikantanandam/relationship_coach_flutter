import 'package:flutter/material.dart';

class RCCard extends StatelessWidget {
  const RCCard({super.key, required this.cardWidget});

  final Widget cardWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surface, // Container background color
        borderRadius: BorderRadius.circular(
          12,
        ), // Optional: for rounded corners
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.shadow, // Shadow color with opacity
            blurRadius: 1, // How soft the shadow should be
            spreadRadius: 0.5, // How much the shadow should spread
            offset: Offset(0, 1), // Shadow position (dx, dy)
          ),
        ],
      ),
      child: cardWidget,
    );
  }
}
