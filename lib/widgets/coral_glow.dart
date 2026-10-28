import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/lerno_colors.dart';

/// Which screen edge the glow bleeds in from.
enum GlowAnchor { top, bottom }

/// Figma "Ellipse 13": a 500 × 500 coral (#FD5454) circle with a 380 layer
/// blur, centred just beyond the top or bottom edge of the screen.
///
/// The blur is pre-computed as a radial falloff so it renders identically
/// on every backend (no runtime blur shader).
class CoralGlow extends StatelessWidget {
  const CoralGlow({
    super.key,
    this.anchor = GlowAnchor.top,
    this.edgeOffset = 40,
  });

  final GlowAnchor anchor;

  /// How far beyond the edge the circle's centre sits.
  final double edgeOffset;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _CoralGlowPainter(anchor, edgeOffset)),
    );
  }
}

class _CoralGlowPainter extends CustomPainter {
  const _CoralGlowPainter(this.anchor, this.edgeOffset);

  final GlowAnchor anchor;
  final double edgeOffset;

  static const _radius = 800.0;
  static const _stops = [0.0, .125, .25, .375, .5, .625, .75, .875, 1.0];
  static const _alphas = [
    .579, .531, .4065, .2575, .133, .0552, .0182, .0047, 0.0, //
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      anchor == GlowAnchor.top ? -edgeOffset : size.height + edgeOffset,
    );
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        _radius,
        [for (final a in _alphas) LernoColors.coral.withValues(alpha: a)],
        _stops,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _CoralGlowPainter old) =>
      old.anchor != anchor || old.edgeOffset != edgeOffset;
}
