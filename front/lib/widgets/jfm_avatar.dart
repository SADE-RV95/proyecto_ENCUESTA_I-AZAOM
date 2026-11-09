import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Avatar circular con las siglas "JFM".
class JfmAvatar extends StatelessWidget {
  final double size;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  const JfmAvatar({
    super.key,
    required this.size,
    required this.fontSize,
    this.backgroundColor = AppColors.brown,
    this.textColor = AppColors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        'JFM',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
