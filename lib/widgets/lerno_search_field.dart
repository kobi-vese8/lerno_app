import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_colors.dart';
import 'lerno_icons.dart';

/// Figma search pill: radius 80, search-01 icon + Montserrat Medium 12
/// (letter-spacing 0.6). Defaults match Add Courses (white 20%, 48 tall,
/// 20px padding); the transcript search overrides size and colours.
class LernoSearchField extends StatelessWidget {
  const LernoSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search street, city, distrct...',
    this.height = 48,
    this.fillColor = const Color(0x33FFFFFF),
    this.leftPadding = 20,
    this.iconSize = 20,
    this.iconGap = 10,
    this.iconColor = LernoColors.white,
    this.hintColor = LernoColors.white,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final double height;
  final Color fillColor;
  final double leftPadding;
  final double iconSize;
  final double iconGap;
  final Color iconColor;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.6,
      color: LernoColors.white,
    );
    return Container(
      height: height,
      padding: EdgeInsets.only(left: leftPadding, right: 20),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        children: [
          LernoIcon(LernoGlyphs.search, size: iconSize, color: iconColor),
          SizedBox(width: iconGap),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: style,
              cursorColor: LernoColors.coral,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: style.copyWith(color: hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
