import 'package:flutter/material.dart';
import 'lerno_colors.dart';

class LernoTextStyles {
  LernoTextStyles._();

  static const String _display = 'MuseoModerno';
  static const String _body = 'Montserrat';
  static const String _logo = 'Audiowide';

  static const TextStyle heroHeadline = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w500,
    fontSize: 40,
    height: 1.2,
    color: LernoColors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 30,
    color: LernoColors.white,
  );

  static const TextStyle cardHeading = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 26,
    color: LernoColors.white,
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: LernoColors.white,
  );

  static const TextStyle lead = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: LernoColors.white,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: LernoColors.white,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: LernoColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: LernoColors.textSecondary,
  );

  static const TextStyle noteTitle = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: LernoColors.white,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: LernoColors.plumDeep,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: LernoColors.coral,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    color: LernoColors.textSecondary,
  );

  static const TextStyle navLabelActive = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w600,
    fontSize: 11,
    color: LernoColors.coral,
  );

  static const TextStyle logo = TextStyle(
    fontFamily: _logo,
    fontWeight: FontWeight.w400,
    fontSize: 28,
    color: LernoColors.white,
    letterSpacing: 2,
  );

  static const TextStyle logoSmall = TextStyle(
    fontFamily: _logo,
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: LernoColors.white,
    letterSpacing: 1.5,
  );
}