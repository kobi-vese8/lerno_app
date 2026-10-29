import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_icons.dart';

/// Profile — built 1:1 from Figma frame "iPhone 16 & 17 Pro - 28"
/// (node 675:495, 402 × 874). Offsets assume a 62pt status bar.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _signOut(BuildContext context) => Navigator.of(context)
      .pushNamedAndRemoveUntil('/welcome', (route) => false);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    void open(String route) => Navigator.of(context).pushNamed(route);

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Stack(
        children: [
          // Ellipse 13 — coral glow centred 270px below the screen.
          const Positioned.fill(
            child: CoralGlow(anchor: GlowAnchor.bottom, edgeOffset: 270),
          ),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, top + 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _GlassBackButton(
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        // y 118 → avatar at 140.
                        const SizedBox(height: 22),
                        const Center(child: _Avatar(initials: 'MS')),
                        // Name y 235, email y 268, chips y 300.
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 33,
                          child: Text(
                            'Maya Singh',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.museoModerno(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.9,
                              color: LernoColors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: Text(
                            'maya.singh@bristol.ac.uk',
                            textAlign: TextAlign.center,
                            style: _montserrat(13, FontWeight.w300,
                                color: const Color(0xB3FFFFFF)),
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _Chip('Year 2', minWidth: 80),
                            SizedBox(width: 9),
                            _Chip('BSc Computer Science', minWidth: 140),
                          ],
                        ),
                        // Chips end y 328 → "STUDY" at 355.
                        const SizedBox(height: 27),
                        const _SectionHeader('STUDY'),
                        _SettingsRow(
                          'Institution & Programme',
                          onTap: () => open('/onboarding/studies'),
                        ),
                        const SizedBox(height: 8),
                        _SettingsRow(
                          'Courses',
                          onTap: () => open('/onboarding/courses'),
                        ),
                        const SizedBox(height: 8),
                        const _SettingsRow('Study preferences'),
                        const SizedBox(height: 25),
                        const _SectionHeader('NOTIFICATIONS & PRIVACY'),
                        const _SettingsRow('Notification settings'),
                        const SizedBox(height: 8),
                        const _SettingsRow('Privacy & data'),
                        const SizedBox(height: 8),
                        const _SettingsRow('Lecture capture'),
                        // Sign out sits 66px above the bottom edge (y 790)
                        // when there is room, otherwise after the list.
                        const Spacer(),
                        const SizedBox(height: 32),
                        Center(
                          child: TextButton(
                            onPressed: () => _signOut(context),
                            style: TextButton.styleFrom(
                              foregroundColor: LernoColors.coral,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign out',
                              style: _montserrat(14, FontWeight.w500,
                                  color: LernoColors.coral),
                            ),
                          ),
                        ),
                        SizedBox(height: math.max(58.0, bottom + 24)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _montserrat(
  double size,
  FontWeight weight, {
  Color color = LernoColors.white,
  double? letterSpacing,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

/// 40px frosted circle: white 20%, 0.84px white-30% border, chevron.
class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ClipOval(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x33FFFFFF),
                border:
                    Border.all(color: const Color(0x4DFFFFFF), width: 0.84),
              ),
              alignment: Alignment.center,
              child: const LernoIcon(LernoGlyphs.chevronLeft,
                  color: LernoColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// 80px #FFF4ED circle with SemiBold 28 plum initials.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF4ED),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: _montserrat(28, FontWeight.w600, color: LernoColors.plumDeep),
      ),
    );
  }
}

/// White 12% pill, 28 tall, Medium 12 label.
class _Chip extends StatelessWidget {
  const _Chip(this.label, {required this.minWidth});

  final String label;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      constraints: BoxConstraints(minWidth: minWidth),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: _montserrat(12, FontWeight.w500)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Text(
        text,
        style: _montserrat(11, FontWeight.w700,
            color: const Color(0x66FFFFFF), letterSpacing: 1.5),
      ),
    );
  }
}

/// White 6% row (48 tall, radius 12): Medium 14 label at x 16 and a 16px
/// white-50% chevron 12px from the right edge.
class _SettingsRow extends StatelessWidget {
  const _SettingsRow(this.label, {this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x0FFFFFFF),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () {},
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _montserrat(14, FontWeight.w500),
                  ),
                ),
                const LernoIcon(LernoGlyphs.chevronRight,
                    color: Color(0x80FFFFFF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
