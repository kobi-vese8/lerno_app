import 'package:flutter/material.dart';

/// Lerno brand color palette.
///
/// Source: Figma file `GreKnItvZJwCUYRWlSJwR4` — brand kit tokens.
class LernoColors {
  LernoColors._();

  // ── Brand primaries ──────────────────────────────────────────────
  static const Color plum = Color(0xFF650034);
  static const Color plumDeep = Color(0xFF3D001F);
  static const Color plumMid = Color(0xFF57002C);
  static const Color cream = Color(0xFFFFE1D6);
  static const Color coral = Color(0xFFFD5454);
  static const Color white = Color(0xFFFFFFFF);

  // ── Audience colours (sticky notes / tags only) ──────────────────
  static const Color admin = Color(0xFFFD5454);
  static const Color educator = Color(0xFFF5845A);
  static const Color student = Color(0xFF00AEEF);

  // ── Neutral ──────────────────────────────────────────────────────
  static const Color hardware = Color(0xFF73757C);
  static const Color ink = Color(0xFF242424);

  // ── Glass ────────────────────────────────────────────────────────
  static const Color glassTrack = Color(0x57FFFFFF); // 34 %
  static const Color glassPill = Color(0x33FFFFFF); // 20 %

  // ── App‑specific (derived from mobile screens) ───────────────────
  static const Color scaffoldDark = Color(0xFF1A0A10);
  static const Color cardDark = Color(0xFF2A1520);
  static const Color inputFill = Color(0xFF31192A);
  static const Color divider = Color(0xFF3A2030);
  static const Color textSecondary = Color(0xFFBBA0AD);
  static const Color teal = Color(0xFF2EC4B6);
  static const Color progressBg = Color(0xFF3A2030);

  // ── Gradients ────────────────────────────────────────────────────
  static const LinearGradient scaffoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [plumDeep, scaffoldDark],
  );

  static const LinearGradient coralGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6B6B), coral],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [plum, plumDeep, scaffoldDark],
  );

  static const LinearGradient lectureCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, Color(0xFFFF7B5C)],
  );
}