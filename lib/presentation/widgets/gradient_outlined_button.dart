import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:flutter/material.dart';

class GradientOutlinedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Gradient gradient;
  final bool isEnable;

  const GradientOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.gradient = const LinearGradient(
      colors: [
        Color(0xFF9B5CED),
        Color(0xFF9658F4),
        Color(0xFF6650DD),
        Color(0xFF5C50C0)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    this.isEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onPressed : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: isEnable ? gradient : null,
          color: isEnable ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 200.0,
          height: 50.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            style: TextCustomStyle.mediumText.copyWith(
              color: isEnable ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
