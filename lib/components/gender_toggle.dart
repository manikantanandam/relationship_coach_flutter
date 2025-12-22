import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';

class GenderToggle extends StatelessWidget {
  final Gender selectedGender;
  final Function(Gender) onChanged;

  const GenderToggle({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Styling constants
    const double width = 300;
    const double height = 60;
    final Color activeColor = Colors.pinkAccent.shade200; // Matching your image

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: Stack(
        children: [
          // The Sliding Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: selectedGender == Gender.male
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: width / 2,
              height: height,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // The Text Labels
          Row(
            children: [
              _buildOption("Male", Gender.male),
              _buildOption("Female", Gender.female),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, Gender value) {
    final bool isSelected = selectedGender == value;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(value),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
