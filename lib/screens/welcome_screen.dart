import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_pill_button.dart';

/// Welcome screen — built 1:1 from Figma frame "iPhone 16 & 17 Pro - 12"
/// (node 258:4666, 402 × 874).
///
/// Every position, rotation and gradient below comes straight from the
/// Figma node transforms, so the pinned role cards land exactly where they
/// sit in the design. The artwork block is laid out on the 402-wide Figma
/// canvas and scales down on narrower / shorter phones.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Stack(
        children: [
          // Blurred coral glow bleeding in from the top (Ellipse 13).
          const Positioned.fill(child: CoralGlow()),

          Column(
            children: [
              // Figma y 0 → 490: role cards + logo mark.
              const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                    child: _HeroArt(),
                  ),
                ),
              ),
              const SizedBox(height: 25.4),

              // Figma y 515 → 758: headline, copy, CTA, log-in link.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _WelcomeContent(
                  onGetStarted: () => Navigator.pushNamed(context, '/signup'),
                  onLogIn: () => Navigator.pushNamed(context, '/login'),
                ),
              ),
              const SizedBox(height: 44.6),

              // Figma y 803 → 850: terms footer.
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: _TermsFooter(),
              ),
              SizedBox(height: math.max(24, bottomInset - 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Typography (Figma: MuseoModerno Medium + Montserrat)
// ═══════════════════════════════════════════════════════════════════════

TextStyle _montserrat(
  double size,
  FontWeight weight, {
  Color color = LernoColors.white,
  double? lineHeightPx,
  List<Shadow>? shadows,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeightPx == null ? null : lineHeightPx / size,
    shadows: shadows,
  );
}

const Color _white70 = Color(0xB3FFFFFF);

// ═══════════════════════════════════════════════════════════════════════
// Helpers
// ═══════════════════════════════════════════════════════════════════════

/// Places [child] using a Figma `relativeTransform`
/// written as `[m00, m01, m02, m10, m11, m12]`.
Widget _place(List<double> m, Widget child) {
  return Positioned(
    left: 0,
    top: 0,
    child: Transform(
      transform: Matrix4(
        m[0], m[3], 0, 0, //
        m[1], m[4], 0, 0, //
        0, 0, 1, 0, //
        m[2], m[5], 0, 1, //
      ),
      child: child,
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════
// Hero artwork: three pinned role cards + logo (402 × 490 Figma canvas)
// ═══════════════════════════════════════════════════════════════════════

class _HeroArt extends StatelessWidget {
  const _HeroArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 402,
      height: 490,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _place(const [0.944, 0.331, 68.141, -0.331, 0.944, 119.124],
              const _RoleCard(spec: _RoleCardSpec.admin)),
          _place(const [-0.993, -0.122, 374.563, -0.122, 0.993, 169.531],
              const _RoleCard(spec: _RoleCardSpec.educator)),
          _place(const [-0.949, -0.317, 183, -0.317, 0.949, 278.507],
              const _RoleCard(spec: _RoleCardSpec.student)),
          _place(const [1, 0, 171, 0, 1, 424.48],
              const SizedBox(
                width: 60,
                height: 64.898,
                child: CustomPaint(painter: _LernoMarkPainter()),
              )),
        ],
      ),
    );
  }
}

/// Everything that differs between the three cards, in Figma local
/// coordinates of the 130 × 130 card.
class _RoleCardSpec {
  const _RoleCardSpec({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.labelTransform,
    required this.illustration,
    required this.illustrationSize,
    required this.illustrationTransform,
    required this.pinTransform,
    required this.foldStart,
    required this.foldEnd,
    required this.foldColors,
    required this.foldStops,
    required this.foldShadowDx,
    required this.foldOnTop,
  });

  final Color color;
  final String title;
  final String subtitle;
  final List<double> labelTransform;
  final String illustration;
  final Size illustrationSize;
  final List<double> illustrationTransform;
  final List<double> pinTransform;
  final Offset foldStart;
  final Offset foldEnd;
  final List<Color> foldColors;
  final List<double> foldStops;
  final double foldShadowDx;
  final bool foldOnTop;

  static const admin = _RoleCardSpec(
    color: LernoColors.admin,
    title: 'For Administration',
    subtitle: 'Automated Quality Assurance & Data-Driven Compliance.',
    labelTransform: [1, 0, 0.148, 0, 1, 19.3],
    illustration: 'assets/welcome/admin_illustration.png',
    illustrationSize: Size(57.2, 85.94),
    illustrationTransform: [1, 0, 36.598, 0, 1, 43.754],
    pinTransform: [-1, 0, 15.341, 0, 1, -12.74],
    foldStart: Offset(96.201, 96.45),
    foldEnd: Offset(122.323, 120.397),
    foldColors: [Color(0xFFFF5858), Color(0xFFDC4B4B)],
    foldStops: [0, 0.657],
    foldShadowDx: 0.52,
    foldOnTop: false,
  );

  static const educator = _RoleCardSpec(
    color: LernoColors.educator,
    title: 'For Educators',
    subtitle: 'Objective Teaching Insights & Automated Reports.',
    labelTransform: [-1, 0, 130.032, 0, 1, 22.462],
    illustration: 'assets/welcome/educator_illustration.png',
    illustrationSize: Size(52.611, 79.045),
    illustrationTransform: [-1, 0, 88.468, 0, 1, 47.915],
    pinTransform: [-1, 0, 15.336, 0, 1, -12.74],
    foldStart: Offset(144.233, 146.87),
    foldEnd: Offset(97.828, 97.11),
    foldColors: [Color(0xFF8F4D35), Color(0xFFF5845A)],
    foldStops: [0, 1],
    foldShadowDx: -0.52,
    foldOnTop: false,
  );

  static const student = _RoleCardSpec(
    color: LernoColors.student,
    title: 'For Students',
    subtitle: 'Smart Transcripts, AI Summaries\n & Study Tools.',
    labelTransform: [-1, 0, 130.22, 0, 1, 18.216],
    illustration: 'assets/welcome/student_illustration.png',
    illustrationSize: Size(58.01, 81.083),
    illustrationTransform: [-1, 0, 88.5, 0, 1, 46.127],
    pinTransform: [-1, 0, 15.339, 0, 1, -12.741],
    foldStart: Offset(135.574, 134.479),
    foldEnd: Offset(95.921, 96.646),
    foldColors: [Color(0xFF006489), Color(0xFF00AEEF)],
    foldStops: [0, 1],
    foldShadowDx: -0.52,
    foldOnTop: true,
  );
}

/// A pinned sticky-note card with a drop shadow (0, 13, blur 10.4, 25%).
class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.spec});

  final _RoleCardSpec spec;

  @override
  Widget build(BuildContext context) {
    final content = _RoleCardContent(spec: spec);
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Figma drop shadow is cast by the whole card (pin included).
          Transform.translate(
            offset: const Offset(0, 13),
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: 5.2,
                sigmaY: 5.2,
                tileMode: TileMode.decal,
              ),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0x40000000),
                  BlendMode.srcIn,
                ),
                child: content,
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}

class _RoleCardContent extends StatelessWidget {
  const _RoleCardContent({required this.spec});

  final _RoleCardSpec spec;

  @override
  Widget build(BuildContext context) {
    final fold = Positioned.fill(
      child: CustomPaint(
        painter: _FoldPainter(
          start: spec.foldStart,
          end: spec.foldEnd,
          colors: spec.foldColors,
          stops: spec.foldStops,
          shadowDx: spec.foldShadowDx,
        ),
      ),
    );

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card body with the bottom-right corner cut off.
          Positioned.fill(
            child: CustomPaint(painter: _CardBodyPainter(spec.color)),
          ),
          if (!spec.foldOnTop) fold,

          // Soft pin-hole shadow under the pushpin.
          _place(
            const [0.944, -0.331, 7.73, 0.331, 0.944, 7.029],
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 0.65, sigmaY: 0.65),
              child: const SizedBox(
                width: 1.82,
                height: 2.08,
                child: ColoredBox(color: Colors.black),
              ),
            ),
          ),

          // Pushpin.
          _place(
            spec.pinTransform,
            Image.asset(
              'assets/welcome/pushpin.png',
              width: 26,
              height: 26,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Title + subtitle.
          _place(
            spec.labelTransform,
            SizedBox(
              width: 130,
              height: 24.6,
              child: _CardLabel(title: spec.title, subtitle: spec.subtitle),
            ),
          ),

          // Illustration.
          _place(
            spec.illustrationTransform,
            Image.asset(
              spec.illustration,
              width: spec.illustrationSize.width,
              height: spec.illustrationSize.height,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),

          if (spec.foldOnTop) fold,
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: _montserrat(7.8, FontWeight.w700),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 12.6,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: _montserrat(
                5.2,
                FontWeight.w500,
                shadows: const [
                  Shadow(color: Color(0x1A000000), blurRadius: 5.564),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rectangle 4329: 130 × 130 with the bottom-right corner cut diagonally.
class _CardBodyPainter extends CustomPainter {
  const _CardBodyPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(130, 0)
      ..lineTo(130, 96.33)
      ..lineTo(96.07, 130)
      ..lineTo(0, 130)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CardBodyPainter old) => old.color != color;
}

/// Polygon 1: the folded-over corner flap, with its gradient and the
/// small 0.52px side shadow.
class _FoldPainter extends CustomPainter {
  const _FoldPainter({
    required this.start,
    required this.end,
    required this.colors,
    required this.stops,
    required this.shadowDx,
  });

  final Offset start;
  final Offset end;
  final List<Color> colors;
  final List<double> stops;
  final double shadowDx;

  static final Path _flap = Path()
    ..moveTo(96.07, 96.33)
    ..lineTo(130, 96.33)
    ..lineTo(96.07, 130)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _flap.shift(Offset(shadowDx, 0)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.52),
    );
    canvas.drawPath(
      _flap,
      Paint()..shader = ui.Gradient.linear(start, end, colors, stops),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The Lerno mark (Group 3): two white strokes, transformed exactly as in
/// Figma inside the 60 × 64.9 frame.
class _LernoMarkPainter extends CustomPainter {
  const _LernoMarkPainter();

  static Float64List _m(List<double> m) => Matrix4(
        m[0], m[3], 0, 0, //
        m[1], m[4], 0, 0, //
        0, 0, 1, 0, //
        m[2], m[5], 0, 1, //
      ).storage;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LernoColors.white
      ..isAntiAlias = true;

    // Vector 258:4669 — the upright stroke.
    final stem = Path()
      ..moveTo(40.457, 0.003)
      ..cubicTo(40.618, -0.019, 40.784, 0.076, 40.904, 0.161)
      ..cubicTo(41.252, 0.408, 43.311, 2.172, 43.368, 2.461)
      ..cubicTo(43.216, 2.710, 41.754, 3.432, 41.397, 3.627)
      ..cubicTo(40.059, 4.348, 38.734, 5.093, 37.422, 5.863)
      ..cubicTo(35.633, 6.929, 33.878, 8.051, 32.159, 9.227)
      ..cubicTo(27.129, 12.691, 22.407, 16.583, 18.047, 20.860)
      ..cubicTo(16.857, 22.037, 15.670, 23.237, 14.532, 24.471)
      ..cubicTo(13.850, 25.209, 13.182, 26.065, 12.473, 26.780)
      ..cubicTo(12.391, 26.863, 12.374, 26.841, 12.284, 26.830)
      ..cubicTo(12.276, 26.811, 12.240, 26.742, 12.238, 26.725)
      ..cubicTo(11.923, 24.504, 12.139, 22.178, 12.844, 20.055)
      ..cubicTo(13.082, 19.340, 13.280, 18.911, 13.537, 18.355)
      ..cubicTo(12.969, 18.759, 12.298, 19.454, 11.771, 19.946)
      ..cubicTo(9.132, 22.415, 6.984, 25.004, 4.846, 27.903)
      ..cubicTo(4.737, 28.078, 4.593, 28.267, 4.473, 28.437)
      ..cubicTo(3.640, 29.615, 2.853, 30.826, 2.100, 32.058)
      ..cubicTo(1.649, 32.805, 1.216, 33.563, 0.803, 34.332)
      ..cubicTo(0.678, 34.563, 0.206, 35.578, 0.003, 35.665)
      ..cubicTo(-0.032, 35.467, 0.289, 34.685, 0.385, 34.419)
      ..cubicTo(1.604, 31.042, 3.179, 27.803, 5.085, 24.759)
      ..cubicTo(6.867, 21.853, 8.976, 19.327, 11.305, 16.874)
      ..cubicTo(17.680, 10.157, 25.698, 5.357, 34.318, 2.093)
      ..cubicTo(35.959, 1.472, 38.781, 0.406, 40.457, 0.003)
      ..close();

    // Vector 258:4670 — the sweeping base stroke.
    final swoosh = Path()
      ..moveTo(7.114, 0.012)
      ..cubicTo(11.448, -0.200, 17.168, 2.491, 20.765, 4.779)
      ..cubicTo(32.702, 12.375, 41.301, 24.620, 46.012, 37.829)
      ..cubicTo(46.333, 38.728, 46.732, 39.613, 46.944, 40.548)
      ..cubicTo(46.493, 39.799, 46.119, 39.089, 45.634, 38.328)
      ..cubicTo(43.884, 35.603, 42.000, 32.966, 39.990, 30.428)
      ..cubicTo(38.611, 28.708, 37.260, 27.168, 35.828, 25.512)
      ..cubicTo(30.533, 19.738, 23.707, 13.770, 16.649, 10.311)
      ..cubicTo(14.570, 9.296, 12.479, 8.548, 10.177, 8.346)
      ..cubicTo(1.730, 7.608, 2.623, 17.258, 3.632, 22.781)
      ..cubicTo(3.747, 23.407, 4.309, 25.008, 4.282, 25.521)
      ..cubicTo(4.262, 25.505, 4.242, 25.489, 4.223, 25.473)
      ..cubicTo(2.318, 21.553, 0.208, 14.248, 0.029, 10.263)
      ..cubicTo(-0.230, 4.504, 1.197, 0.430, 7.114, 0.012)
      ..close();

    canvas.drawPath(
      stem.transform(_m(const [0.608, 0.794, 5.394, 0.794, -0.608, 22.338])),
      paint,
    );
    canvas.drawPath(
      swoosh.transform(_m(const [0.608, 0.794, -1.766, 0.794, -0.608, 46.992])),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════
// Headline, copy, CTA and log-in link (Figma frame 258:6018, 342 × 243)
// ═══════════════════════════════════════════════════════════════════════

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent({required this.onGetStarted, required this.onLogIn});

  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 38,
          width: double.infinity,
          child: Text(
            'Welcome to lerno',
            textAlign: TextAlign.center,
            style: GoogleFonts.museoModerno(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              height: 37.8 / 30,
              letterSpacing: -0.9,
              color: LernoColors.white,
            ),
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 47,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 337 / 342,
              child: Text(
                'Lerno turns lectures into clear notes, summaries, flashcards, and practice.',
                textAlign: TextAlign.center,
                style: _montserrat(14, FontWeight.w500,
                    color: _white70, lineHeightPx: 23.25),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        LernoPillButton(label: 'Get Started', onPressed: onGetStarted),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: onLogIn,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 24,
            width: double.infinity,
            child: Text.rich(
              TextSpan(
                style: _montserrat(14, FontWeight.w500,
                    color: _white70, lineHeightPx: 23.25),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Log in',
                    style: _montserrat(14, FontWeight.w600,
                        lineHeightPx: 23.25),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsFooter extends StatelessWidget {
  const _TermsFooter();

  @override
  Widget build(BuildContext context) {
    final regular =
        _montserrat(10, FontWeight.w500, color: _white70, lineHeightPx: 23.25);
    final strong = _montserrat(10, FontWeight.w600, lineHeightPx: 23.25);

    return SizedBox(
      height: 47,
      width: double.infinity,
      child: Text.rich(
        TextSpan(
          style: regular,
          children: [
            const TextSpan(text: 'By tapping Get Started, I agree with the '),
            TextSpan(text: 'Terms of Service', style: strong),
            const TextSpan(text: ' and '),
            TextSpan(text: 'Privacy Policy. ', style: strong),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
