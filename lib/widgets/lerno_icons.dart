import 'package:flutter/widgets.dart';

/// Lerno's icon set, drawn from the exact Figma vector paths.
///
/// Usage: `LernoIcon(LernoGlyphs.bell, size: 20, color: LernoColors.coral)`.
class LernoIcon extends StatelessWidget {
  const LernoIcon(
    this.glyph, {
    super.key,
    this.size,
    required this.color,
    this.semanticLabel,
  });

  final LernoGlyph glyph;

  /// Rendered width; height follows the glyph's aspect ratio.
  /// Defaults to the glyph's native Figma size.
  final double? size;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final w = size ?? glyph.width;
    final h = w * glyph.height / glyph.width;
    final icon = CustomPaint(
      size: Size(w, h),
      painter: _GlyphPainter(glyph, color),
    );
    if (semanticLabel == null) return ExcludeSemantics(child: icon);
    return Semantics(label: semanticLabel, child: icon);
  }
}

/// One drawable part of a glyph: an absolute SVG path (M/L/C/Z) placed at
/// [dx], [dy], either stroked or filled.
class GlyphPart {
  const GlyphPart(
    this.d, {
    this.dx = 0,
    this.dy = 0,
    this.stroke,
    this.roundCap = true,
  });

  final String d;
  final double dx;
  final double dy;

  /// Stroke width, or null to fill.
  final double? stroke;
  final bool roundCap;
}

class LernoGlyph {
  const LernoGlyph(this.width, this.height, this.parts);

  final double width;
  final double height;
  final List<GlyphPart> parts;
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.glyph, this.color);

  final LernoGlyph glyph;
  final Color color;

  static final Map<String, Path> _cache = {};

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / glyph.width, size.height / glyph.height);
    for (final part in glyph.parts) {
      final path = (_cache[part.d] ??= _parseSvgPath(part.d))
          .shift(Offset(part.dx, part.dy));
      final paint = Paint()
        ..color = color
        ..isAntiAlias = true;
      if (part.stroke != null) {
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = part.stroke!
          ..strokeCap = part.roundCap ? StrokeCap.round : StrokeCap.butt
          ..strokeJoin = StrokeJoin.round;
      }
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter old) =>
      old.glyph != glyph || old.color != color;
}

/// Minimal parser for Figma's absolute path data (M, L, C, Z).
Path _parseSvgPath(String d) {
  final tokens = RegExp(r'[MLCZ]|-?\d*\.?\d+(?:e-?\d+)?')
      .allMatches(d)
      .map((m) => m.group(0)!)
      .toList();
  final path = Path();
  var i = 0;
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    switch (tokens[i++]) {
      case 'M':
        path.moveTo(n(), n());
      case 'L':
        path.lineTo(n(), n());
      case 'C':
        path.cubicTo(n(), n(), n(), n(), n(), n());
      case 'Z':
        path.close();
    }
  }
  return path;
}

/// Glyphs exported from the Lerno Figma file.
abstract final class LernoGlyphs {
  /// search-01 (20 × 20, stroke 1.25).
  static const search = LernoGlyph(20, 20, [
    GlyphPart(
        'M 13.333 6.667 C 13.333 2.985 10.349 0 6.667 0 C 2.985 0 0 2.985 0 6.667 C 0 10.349 2.985 13.333 6.667 13.333 C 10.349 13.333 13.333 10.349 13.333 6.667 Z',
        dx: 2.5,
        dy: 2.5,
        stroke: 1.25),
    GlyphPart('M 0 0 L 3.333 3.333', dx: 14.167, dy: 14.167, stroke: 1.25),
  ]);

  /// Back chevron (20 × 20, stroke 1.5).
  static const chevronLeft = LernoGlyph(20, 20, [
    GlyphPart('M 5 0 L 0 5 L 5 10', dx: 7, dy: 5, stroke: 1.5),
  ]);

  /// Close / cancel cross (16 × 16), used on the study-session header.
  static const close = LernoGlyph(16, 16, [
    GlyphPart('M 9.333 0 L 0 9.333 M 0 0 L 9.333 9.333',
        dx: 3.333, dy: 3.333, stroke: 1.33),
  ]);

  /// Recording indicator: ring + dot (12 × 12).
  static const recording = LernoGlyph(12, 12, [
    GlyphPart(
        'M 8 4 C 8 6.209 6.209 8 4 8 C 1.791 8 0 6.209 0 4 C 0 1.791 1.791 0 4 0 C 6.209 0 8 1.791 8 4 Z',
        dx: 2,
        dy: 2,
        stroke: 1.2,
        roundCap: false),
    GlyphPart(
        'M 4 2 C 4 3.105 3.105 4 2 4 C 0.895 4 0 3.105 0 2 C 0 0.895 0.895 0 2 0 C 3.105 0 4 0.895 4 2 Z',
        dx: 4,
        dy: 4),
  ]);

  /// Info circle (14 × 14, stroke 1).
  static const info = LernoGlyph(14, 14, [
    GlyphPart(
        'M 12 6 C 12 9.314 9.314 12 6 12 C 2.686 12 0 9.314 0 6 C 0 2.686 2.686 0 6 0 C 9.314 0 12 2.686 12 6 Z',
        dx: 1,
        dy: 1,
        stroke: 1,
        roundCap: false),
    GlyphPart('M 0 0 L 0 3.5 M 0 5.5 L 0 6', dx: 7, dy: 4, stroke: 1),
  ]);

  /// clock-hour-5 (20 × 20, stroke 1.25).
  static const clock = LernoGlyph(20, 20, [
    GlyphPart(
        'M 16.667 8.333 C 16.667 12.936 12.936 16.667 8.333 16.667 C 3.731 16.667 0 12.936 0 8.333 C 0 3.731 3.731 0 8.333 0 C 12.936 0 16.667 3.731 16.667 8.333 Z',
        dx: 1.667,
        dy: 1.667,
        stroke: 1.25),
    GlyphPart('M 0 0 L 0 5 L 1.667 7.917', dx: 10, dy: 5, stroke: 1.25),
  ]);

  /// play (18 × 18, stroke 1.125).
  static const play = LernoGlyph(18, 18, [
    GlyphPart(
        'M 10.418 6.259 C 10.153 7.267 8.9 7.978 6.394 9.402 C 3.972 10.778 2.761 11.466 1.785 11.19 C 1.381 11.075 1.014 10.858 0.717 10.559 C 0 9.835 0 8.432 0 5.625 C 0 2.818 0 1.415 0.717 0.691 C 1.014 0.392 1.381 0.175 1.785 0.06 C 2.761 -0.216 3.972 0.472 6.394 1.848 C 8.9 3.271 10.153 3.983 10.418 4.99 C 10.527 5.406 10.527 5.844 10.418 6.259 Z',
        dx: 3.75,
        dy: 3.375,
        stroke: 1.125,
        roundCap: false),
  ]);

  /// bookmark-02 (24 × 24, stroke 1.5).
  static const bookmark = LernoGlyph(24, 24, [
    GlyphPart(
        'M 0 15.981 L 0 7.708 C 0 4.074 0 2.257 1.172 1.129 C 2.343 0 4.229 0 8 0 C 11.771 0 13.657 0 14.828 1.129 C 16 2.257 16 4.074 16 7.708 L 16 15.981 C 16 18.287 16 19.44 15.227 19.852 C 13.73 20.651 10.923 17.985 9.59 17.182 C 8.817 16.717 8.43 16.484 8 16.484 C 7.57 16.484 7.183 16.717 6.41 17.182 C 5.077 17.985 2.269 20.651 0.773 19.852 C 0 19.44 0 18.287 0 15.981 Z',
        dx: 4,
        dy: 2,
        stroke: 1.5),
  ]);

  /// location-01 (14 × 14, stroke 0.78).
  static const location = LernoGlyph(14, 14, [
    GlyphPart(
        'M 6.194 11.297 C 5.941 11.534 5.603 11.667 5.251 11.667 C 4.899 11.667 4.561 11.534 4.308 11.297 C 1.991 9.115 -1.114 6.677 0.4 3.138 C 1.219 1.225 3.184 0 5.251 0 C 7.317 0 9.282 1.225 10.101 3.138 C 11.613 6.673 8.516 9.123 6.194 11.297 Z',
        dx: 1.75,
        dy: 1.167,
        stroke: 0.778,
        roundCap: false),
    GlyphPart(
        'M 4.083 2.042 C 4.083 3.169 3.169 4.083 2.042 4.083 C 0.914 4.083 0 3.169 0 2.042 C 0 0.914 0.914 0 2.042 0 C 3.169 0 4.083 0.914 4.083 2.042 Z',
        dx: 4.958,
        dy: 4.375,
        stroke: 0.778,
        roundCap: false),
  ]);

  /// Small bell used on schedule cards (20 × 20.82, stroke 1.06).
  static const bellSmall = LernoGlyph(20, 20.822, [
    GlyphPart(
        'M 1.314 11.324 L 12.019 11.324 C 12.534 11.324 12.792 11.324 12.941 11.25 C 13.231 11.106 13.386 10.783 13.317 10.467 C 13.282 10.304 13.121 10.103 12.8 9.701 L 12.679 9.551 C 12.357 9.147 12.195 8.946 12.059 8.734 C 11.635 8.077 11.372 7.328 11.293 6.55 C 11.267 6.299 11.267 6.041 11.267 5.524 L 11.267 4.6 C 11.267 4.272 11.267 4.108 11.258 3.969 C 11.119 1.842 9.425 0.148 7.298 0.009 C 7.16 0 6.995 0 6.667 0 C 6.338 0 6.174 0 6.035 0.009 C 3.909 0.148 2.215 1.842 2.075 3.969 C 2.066 4.108 2.066 4.272 2.066 4.6 L 2.066 5.524 C 2.066 6.041 2.066 6.299 2.041 6.55 C 1.961 7.328 1.699 8.077 1.274 8.734 C 1.138 8.946 0.977 9.147 0.654 9.551 L 0.534 9.701 C 0.212 10.103 0.051 10.304 0.016 10.467 C -0.052 10.783 0.103 11.106 0.392 11.25 C 0.541 11.324 0.799 11.324 1.314 11.324 Z',
        dx: 3.333,
        dy: 3.333,
        stroke: 1.062,
        roundCap: false),
    GlyphPart(
        'M 5.662 0 C 5.662 1.563 4.395 2.831 2.831 2.831 C 1.267 2.831 0 1.563 0 0',
        dx: 7.169,
        dy: 14.657,
        stroke: 1.062),
  ]);

  /// home-08 / Filled (24 × 24) — active tab.
  static const homeFilled = LernoGlyph(24, 24, [
    GlyphPart(
        'M 0 7.5 L 5.635 2.472 C 7.482 0.824 8.405 0 9.5 0 C 10.595 0 11.518 0.824 13.365 2.472 L 19 7.5 L 17.5 7.5 L 17.5 12.001 C 17.5 15.301 17.5 16.951 16.475 17.976 C 15.45 19.001 13.8 19.001 10.5 19.001 L 10.249 19.001 L 10.249 12 C 10.249 11.586 9.914 11.25 9.499 11.25 C 9.085 11.25 8.749 11.586 8.749 12 L 8.749 19.001 L 8.5 19.001 C 5.2 19.001 3.55 19.001 2.525 17.976 C 1.5 16.951 1.5 15.301 1.5 12.001 L 1.5 7.5 L 0 7.5 Z',
        dx: 2.5,
        dy: 2.5),
    ..._homeStrokes,
  ]);

  /// home-08 outline (24 × 24) — inactive tab.
  static const homeOutline = LernoGlyph(24, 24, _homeStrokes);

  static const _homeStrokes = [
    GlyphPart(
        'M 0 0 L 0 5.501 C 0 8.801 0 10.451 1.025 11.476 C 2.05 12.501 3.7 12.501 7 12.501 L 9 12.501 C 12.3 12.501 13.95 12.501 14.975 11.476 C 16 10.451 16 8.801 16 5.501 L 16 0',
        dx: 4,
        dy: 9,
        stroke: 1.5),
    GlyphPart(
        'M 19 7.5 L 13.365 2.472 C 11.518 0.824 10.595 0 9.5 0 C 8.405 0 7.482 0.824 5.635 2.472 L 0 7.5',
        dx: 2.5,
        dy: 2.5,
        stroke: 1.5),
  ];

  /// teacher (25 × 25, stroke 1.56) — Lectures tab.
  static const teacher = LernoGlyph(25, 25, [
    GlyphPart(
        'M 0 0 L 14.583 0 C 16.547 0 17.53 0 18.14 0.61 C 18.75 1.22 18.75 2.202 18.75 4.167 L 18.75 10.417 C 18.75 12.381 18.75 13.363 18.14 13.973 C 17.53 14.583 16.547 14.583 14.583 14.583 L 7.292 14.583',
        dx: 2.083,
        dy: 2.083,
        stroke: 1.5625),
    GlyphPart('M 0 0 L 6.25 0', dx: 10.417, dy: 6.771, stroke: 1.5625),
    GlyphPart(
        'M 0 6.25 L 0 2.083 C 0 1.101 0 0.61 0.305 0.305 C 0.61 0 1.101 0 2.083 0 L 4.167 0 M 0 6.25 L 4.167 6.25 M 0 6.25 L 0 11.458 M 4.167 0 L 4.167 6.25 M 4.167 0 L 7.292 0 L 10.417 0 M 4.167 6.25 L 4.167 11.458',
        dx: 2.083,
        dy: 11.458,
        stroke: 1.5625),
    GlyphPart(
        'M 4.167 2.083 C 4.167 3.234 3.234 4.167 2.083 4.167 C 0.933 4.167 0 3.234 0 2.083 C 0 0.933 0.933 0 2.083 0 C 3.234 0 4.167 0.933 4.167 2.083 Z',
        dx: 2.083,
        dy: 4.688,
        stroke: 1.5625,
        roundCap: false),
  ]);

  /// graduation-cap (25 × 25, stroke 1.56) — Study tab.
  static const graduationCap = LernoGlyph(25, 25, [
    GlyphPart(
        'M 7.856 0.94 L 5.191 2.265 C 1.73 3.986 0 4.846 0 6.25 C 0 7.654 1.73 8.514 5.191 10.235 L 7.856 11.56 C 9.116 12.187 9.746 12.5 10.417 12.5 C 11.088 12.5 11.718 12.187 12.978 11.56 L 15.643 10.235 C 19.103 8.514 20.833 7.654 20.833 6.25 C 20.833 4.846 19.103 3.986 15.643 2.265 L 12.978 0.94 C 11.718 0.313 11.088 0 10.417 0 C 9.746 0 9.116 0.313 7.856 0.94 Z',
        dx: 2.083,
        dy: 3.906,
        stroke: 1.5625),
    GlyphPart(
        'M 0 0 L 0 3.966 C 0 4.061 0 4.109 0.002 4.153 C 0.032 4.889 0.439 5.556 1.074 5.913 C 1.113 5.934 1.155 5.955 1.239 5.998 C 1.583 6.172 1.755 6.26 1.921 6.337 C 4.671 7.61 7.829 7.61 10.579 6.337 C 10.745 6.26 10.917 6.172 11.261 5.998 C 11.345 5.955 11.387 5.934 11.426 5.913 C 12.061 5.556 12.468 4.889 12.498 4.153 C 12.5 4.109 12.5 4.061 12.5 3.966 L 12.5 0',
        dx: 6.25,
        dy: 13.802,
        stroke: 1.5625),
    GlyphPart('M 0 0 L 0 6.771', dx: 22.917, dy: 10.156, stroke: 1.5625),
  ]);

  /// calendar-05 (25 × 25, stroke 1.56) — Reminders tab.
  static const calendar = LernoGlyph(25, 25, [
    GlyphPart('M 8.333 0 L 8.333 4.167 M 0 0 L 0 4.167',
        dx: 8.333, dy: 2.083, stroke: 1.5625),
    GlyphPart(
        'M 10.417 0 L 8.333 0 C 4.405 0 2.441 0 1.22 1.22 C 0 2.441 0 4.405 0 8.333 L 0 10.417 C 0 14.345 0 16.309 1.22 17.53 C 2.441 18.75 4.405 18.75 8.333 18.75 L 10.417 18.75 C 14.345 18.75 16.309 18.75 17.53 17.53 C 18.75 16.309 18.75 14.345 18.75 10.417 L 18.75 8.333 C 18.75 4.405 18.75 2.441 17.53 1.22 C 16.309 0 14.345 0 10.417 0 Z',
        dx: 3.125,
        dy: 4.167,
        stroke: 1.5625),
    GlyphPart('M 0 0 L 18.75 0', dx: 3.125, dy: 10.417, stroke: 1.5625),
    GlyphPart(
        'M 1.563 0.521 L 1.563 2.604 M 3.125 1.563 C 3.125 2.425 2.425 3.125 1.563 3.125 C 0.7 3.125 0 2.425 0 1.563 C 0 0.7 0.7 0 1.563 0 C 2.425 0 3.125 0.7 3.125 1.563 Z',
        dx: 14.583,
        dy: 15.625,
        stroke: 1.5625),
  ]);
}
