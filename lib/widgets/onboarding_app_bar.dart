import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_colors.dart';

/// Onboarding header from Figma (frames 258:7376 and siblings):
/// frosted-glass back button, MuseoModerno title, "Step x to y" caption and
/// a full-width progress track.
///
/// Figma positions are measured on an iPhone 16 Pro whose status bar is
/// 62pt tall, so everything is offset from the device's real top inset.
class OnboardingAppBar extends StatelessWidget {
  const OnboardingAppBar({
    super.key,
    required this.title,
    required this.step,
    this.totalSteps = 3,
    this.onBack,
    this.progressOpacity = 1,
  });

  final String title;
  final int step;
  final int totalSteps;
  final VoidCallback? onBack;

  /// Opacity of the coral progress fill (Figma uses 0.8 on step 2).
  final double progressOpacity;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;

    return SizedBox(
      height: top + 86,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Figma (19.75, 78) — 40 × 39.58.
          Positioned(
            left: 19.75,
            top: top + 16,
            child: _GlassBackButton(
              onTap: onBack ?? () => Navigator.maybePop(context),
            ),
          ),

          // Figma (79.75, 71) — title 37.8 tall, caption pulled up 8px.
          Positioned(
            left: 79.75,
            right: 20,
            top: top + 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 37.8,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.museoModerno(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 37.8 / 20,
                      letterSpacing: -0.9,
                      color: LernoColors.white,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: SizedBox(
                    height: 23.25,
                    child: Text(
                      'Step $step to $totalSteps',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 23.25 / 12,
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Figma y 144 — 4px track.
          Positioned(
            left: 0,
            right: 0,
            top: top + 82,
            child: _ProgressTrack(
              progress: step / totalSteps,
              opacity: progressOpacity,
            ),
          ),
        ],
      ),
    );
  }
}

/// White 20% frosted circle with a thin stroked chevron.
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
              height: 39.579,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x33FFFFFF),
                border: Border.all(color: const Color(0x1FFFFFFF), width: 0.8),
              ),
              child: const CustomPaint(painter: _BackChevronPainter()),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackChevronPainter extends CustomPainter {
  const _BackChevronPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Figma vector 258:7459 at (16.842, 13.474), stroke 1.58, round caps.
    const dx = 16.842, dy = 13.474;
    final path = Path()
      ..moveTo(dx + 6.316, dy)
      ..cubicTo(dx + 6.316, dy, dx, dy + 4.651, dx, dy + 6.316)
      ..cubicTo(dx, dy + 7.980, dx + 6.316, dy + 12.632, dx + 6.316,
          dy + 12.632);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.579
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = LernoColors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Full-width white 10% track with a coral fill rounded on the right.
class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.progress, required this.opacity});

  final double progress;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: const BoxDecoration(
        color: Color(0x1AFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 0.8),
            // Figma blur 12 ≈ Gaussian σ 6.
            blurRadius: 9.5,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: progress.clamp(0.0, 1.0),
        heightFactor: 1,
        child: Opacity(
          opacity: opacity,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: LernoColors.coral,
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(40)),
            ),
          ),
        ),
      ),
    );
  }
}
