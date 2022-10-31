import 'package:flutter/material.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/common/text/fonts.dart';

class UnitRoundedText extends StatelessWidget {
  final String text;
  final bool bold;
  final Color color;
  final bool centerText;
  final int? maxLines;
  final double fontSize;
  final bool underline;
  final bool hasShadow;

  const UnitRoundedText(
    this.text, {
    super.key,
    this.color = AppColors.textDark,
    this.centerText = false,
    this.underline = false,
    this.bold = false,
    this.fontSize = 16,
    this.maxLines,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: unitRoundedTextStyle.copyWith(
        fontWeight: bold ? FontWeight.w700 : null,
        fontSize: fontSize,
        color: color,
        decoration: underline ? TextDecoration.underline : null,
        shadows: !hasShadow
            ? []
            : [
                BoxShadow(
                  color: AppColors.textDark.withOpacity(0.2),
                  blurRadius: 13,
                  offset: const Offset(0, 13),
                ),
              ],
      ),
      maxLines: maxLines,
      textAlign: centerText ? TextAlign.center : null,
    );
  }
}
