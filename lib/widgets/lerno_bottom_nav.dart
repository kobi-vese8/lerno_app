import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_colors.dart';
import 'lerno_icons.dart';

enum LernoTab { home, lectures, study, reminders }

/// Floating glass tab bar from Figma ("navraj", 362 × 63).
///
/// Place it in a [Stack] over the page content; it positions itself 21pt
/// above the bottom edge (13pt overlap with the iOS home indicator), as in
/// the design. Tapping a tab navigates to that tab's route unless [onTap]
/// is supplied.
class LernoBottomNav extends StatelessWidget {
  const LernoBottomNav({super.key, required this.current, this.onTap});

  final LernoTab current;
  final ValueChanged<LernoTab>? onTap;

  /// Height of the bar plus its gap to the screen edge — use as bottom
  /// padding for scrolling content behind the bar.
  static double reservedHeight(BuildContext context) =>
      63 + _bottomGap(context);

  static double _bottomGap(BuildContext context) =>
      math.max(21.0, MediaQuery.viewPaddingOf(context).bottom - 13);

  static const _routes = {
    LernoTab.home: '/home',
    LernoTab.lectures: '/lecture-detail',
    LernoTab.study: '/flashcards',
    LernoTab.reminders: '/reminders',
  };

  // Figma item widths (32 / 42 / 37 / 33) with 50px gaps, centred in 362.
  static const _itemWidths = [32.0, 42.0, 37.0, 33.0];
  static const _gap = 50.0;

  void _handleTap(BuildContext context, LernoTab tab) {
    if (onTap != null) return onTap!(tab);
    if (tab == current) return;
    Navigator.pushReplacementNamed(context, _routes[tab]!);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _bottomGap(context),
      child: Center(
        child: Container(
          width: 362,
          height: 63,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                offset: Offset(0, 20),
                blurRadius: 60,
                spreadRadius: 6,
              ),
              BoxShadow(
                color: Color(0x4D000000),
                offset: Offset(0, -20),
                blurRadius: 60,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: ColoredBox(
                // Rendered colour of the Figma glass stack (#242424 @ 90%
                // under a blurred 50% black layer).
                color: const Color(0xF2201A1B),
                child: _buildItems(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    final total =
        _itemWidths.reduce((a, b) => a + b) + _gap * (_itemWidths.length - 1);
    var x = (362 - total) / 2 + 0.5;
    final centres = <double>[];
    for (final w in _itemWidths) {
      centres.add(x + w / 2);
      x += w + _gap;
    }
    final activeIndex = current.index;
    final pillLeft =
    (centres[activeIndex] - 47.5).clamp(3.0, 362.0 - 3 - 95);

    return Stack(
      children: [
        // Active pill: 95 × 57, coral.
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          left: pillLeft,
          top: 3,
          child: Container(
            width: 95,
            height: 57,
            decoration: BoxDecoration(
              color: LernoColors.coral,
              borderRadius: BorderRadius.circular(50.893),
            ),
          ),
        ),
        for (final tab in LernoTab.values)
          Positioned(
            left: centres[tab.index] - 47.5,
            top: 0,
            width: 95,
            height: 63,
            child: _NavItem(
              tab: tab,
              active: tab == current,
              onTap: () => _handleTap(context, tab),
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.active, required this.onTap});

  final LernoTab tab;
  final bool active;
  final VoidCallback onTap;

  static const _labels = {
    LernoTab.home: 'Home',
    LernoTab.lectures: 'Lectures',
    LernoTab.study: 'Study',
    LernoTab.reminders: 'Reminders',
  };

  @override
  Widget build(BuildContext context) {
    final color = active ? LernoColors.plumDeep : LernoColors.white;
    final glyph = switch (tab) {
      LernoTab.home => active ? LernoGlyphs.homeFilled : LernoGlyphs.homeOutline,
      LernoTab.lectures => LernoGlyphs.teacher,
      LernoTab.study => LernoGlyphs.graduationCap,
      LernoTab.reminders => LernoGlyphs.calendar,
    };

    return Semantics(
      button: true,
      selected: active,
      label: _labels[tab],
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LernoIcon(glyph, color: color),
              const SizedBox(height: 2),
              MediaQuery.withNoTextScaling(
                child: Text(
                  _labels[tab]!,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}