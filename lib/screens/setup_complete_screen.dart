import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_pill_button.dart';
import '../widgets/onboarding_app_bar.dart';

/// Onboarding step 3 — built 1:1 from Figma frame
/// "iPhone 16 & 17 Pro - 14" (node 304:7570, 402 × 874).
class SetupCompleteScreen extends StatelessWidget {
  const SetupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Stack(
        children: [
          // Ellipse 13 — coral glow centred 200px below the screen.
          const Positioned.fill(
            child: CoralGlow(anchor: GlowAnchor.bottom, edgeOffset: 200),
          ),

          Column(
            children: [
              OnboardingAppBar(
                title: 'Your lectures handled with care',
                step: 3,
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Figma y 148 → 303: the pinned lock note.
                      const SizedBox(
                        height: 155,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _PinnedLockNote(),
                          ],
                        ),
                      ),

                      // Figma (20, 303) — 362 wide, 30px gaps.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 21.7,
                              child: Text(
                                'Know when capture is active',
                                style: _montserrat(18, FontWeight.w600,
                                    lineHeightPx: 21.7),
                              ),
                            ),
                            const SizedBox(height: 5),
                            ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 353),
                              child: Text(
                                'We’ll use this to organise your lectures and tailor study tools.',
                                style: _montserrat(14, FontWeight.w300,
                                    lineHeightPx: 21.7, color: _white70),
                              ),
                            ),
                            const SizedBox(height: 30),
                            const _StepRow(
                              number: '01',
                              lead: 'Your lecturer starts capture',
                              rest: ' during the scheduled class.',
                              restWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 20),
                            const _StepRow(
                              number: '02',
                              lead: 'Lerno organises the lecture',
                              rest: ' into searchable study materials.',
                            ),
                            const SizedBox(height: 20),
                            const _StepRow(
                              number: '03',
                              lead: 'You choose how to study.',
                              rest: ' Lerno does not evaluate or grade you.',
                            ),
                            const SizedBox(height: 30),
                            _NotificationCard(onAllow: () {}),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Figma (30, 770) — pinned 50px above the bottom edge.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LernoPillButton(
                  label: 'Continue',
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
              ),
              SizedBox(height: math.max(50, bottomInset + 16)),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Typography & helpers
// ═══════════════════════════════════════════════════════════════════════

const Color _white70 = Color(0xB3FFFFFF);

TextStyle _montserrat(
  double size,
  FontWeight weight, {
  Color color = LernoColors.white,
  double? lineHeightPx,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeightPx == null ? null : lineHeightPx / size,
  );
}

Paint _stroke(Color color, double width) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..color = color;

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
// Pinned lock note (Figma 410:3307) — 80 × 80, rotated −11.95°
// ═══════════════════════════════════════════════════════════════════════

class _PinnedLockNote extends StatelessWidget {
  const _PinnedLockNote();

  @override
  Widget build(BuildContext context) {
    const content = _LockNoteContent();
    // Frame origin in Figma is (34, 195.563); the band starts at y 148.
    return _place(
      const [0.978, 0.207, 34, -0.207, 0.978, 47.563],
      SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Drop shadow 0/8 blur 6.4 @ 25% cast by the whole note.
            Transform.translate(
              offset: const Offset(0, 8),
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 3.2,
                  sigmaY: 3.2,
                  tileMode: TileMode.decal,
                ),
                child: const ColorFiltered(
                  colorFilter: ColorFilter.mode(
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
      ),
    );
  }
}

class _LockNoteContent extends StatelessWidget {
  const _LockNoteContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: CustomPaint(painter: _NotePainter())),

          // Soft pin-hole shadow.
          _place(
            const [0.944, -0.331, 4.226, 0.331, 0.944, 3.001],
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 1.07, sigmaY: 1.07),
              child: const SizedBox(
                width: 3,
                height: 3.429,
                child: ColoredBox(color: Colors.black),
              ),
            ),
          ),

          // Pushpin (mirrored, 30 × 30).
          _place(
            const [-1, 0, 13.355, 0, 1, -19.581],
            Image.asset(
              'assets/welcome/pushpin.png',
              width: 30,
              height: 30,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),

          // square-lock-02 icon at (19.562, 20.059).
          _place(
            const [1, 0, 19.562, 0, 1, 20.059],
            const CustomPaint(size: Size(40, 40), painter: _LockPainter()),
          ),
        ],
      ),
    );
  }
}

/// Coral note with the bottom-right corner cut and folded over.
class _NotePainter extends CustomPainter {
  const _NotePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final body = Path()
      ..moveTo(0, 0)
      ..lineTo(80, 0)
      ..lineTo(80, 59.28)
      ..lineTo(59.12, 80)
      ..lineTo(0, 80)
      ..close();
    canvas.drawPath(body, Paint()..color = LernoColors.admin);

    final flap = Path()
      ..moveTo(59.121, 59.28)
      ..lineTo(80.001, 59.28)
      ..lineTo(59.121, 80)
      ..close();
    canvas.drawPath(
      flap.shift(const Offset(0.32, 0)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.32),
    );
    canvas.drawPath(
      flap,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(59.201, 59.354),
          const Offset(75.277, 74.09),
          const [Color(0xFFFF5858), Color(0xFFDC4B4B)],
          const [0, 0.657],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Figma "square-lock-02": deep-plum 2.5px strokes on a 40 × 40 canvas.
class _LockPainter extends CustomPainter {
  const _LockPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = _stroke(LernoColors.plumDeep, 2.5);

    final keyhole = Path()
      ..moveTo(20.000, 24.167)
      ..lineTo(20.000, 29.167)
      ..moveTo(21.666, 24.167)
      ..cubicTo(21.666, 25.087, 20.920, 25.833, 20.000, 25.833)
      ..cubicTo(19.079, 25.833, 18.333, 25.087, 18.333, 24.167)
      ..cubicTo(18.333, 23.246, 19.079, 22.500, 20.000, 22.500)
      ..cubicTo(20.920, 22.500, 21.666, 23.246, 21.666, 24.167)
      ..close();
    final shackle = Path()
      ..moveTo(27.498, 15.000)
      ..lineTo(27.498, 10.833)
      ..cubicTo(27.498, 6.691, 24.140, 3.333, 19.998, 3.333)
      ..cubicTo(15.856, 3.333, 12.498, 6.691, 12.498, 10.833)
      ..lineTo(12.498, 15.000);
    final body = Path()
      ..moveTo(7.111, 31.408)
      ..cubicTo(7.486, 34.192, 9.792, 36.372, 12.598, 36.501)
      ..cubicTo(14.959, 36.610, 17.357, 36.667, 19.998, 36.667)
      ..cubicTo(22.640, 36.667, 25.038, 36.610, 27.399, 36.501)
      ..cubicTo(30.205, 36.372, 32.511, 34.192, 32.885, 31.408)
      ..cubicTo(33.130, 29.591, 33.332, 27.729, 33.332, 25.833)
      ..cubicTo(33.332, 23.937, 33.130, 22.076, 32.885, 20.259)
      ..cubicTo(32.511, 17.475, 30.205, 15.294, 27.399, 15.165)
      ..cubicTo(25.038, 15.057, 22.640, 15.000, 19.998, 15.000)
      ..cubicTo(17.357, 15.000, 14.959, 15.057, 12.598, 15.165)
      ..cubicTo(9.792, 15.294, 7.486, 17.475, 7.111, 20.259)
      ..cubicTo(6.867, 22.076, 6.665, 23.937, 6.665, 25.833)
      ..cubicTo(6.665, 27.729, 6.867, 29.591, 7.111, 31.408)
      ..close();

    canvas.drawPath(keyhole, paint);
    canvas.drawPath(shackle, paint);
    canvas.drawPath(body, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════
// Numbered steps (Figma 444:6046)
// ═══════════════════════════════════════════════════════════════════════

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.lead,
    required this.rest,
    this.restWeight = FontWeight.w400,
  });

  final String number;
  final String lead;
  final String rest;
  final FontWeight restWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 30px badge sitting on a 14px bottom pad, as in Figma.
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF3B2431),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 11,
                  child: MediaQuery.withNoTextScaling(
                    child: Text(
                      number,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.kufam(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 11.232 / 12,
                        color: const Color(0xFFF4CFE1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: lead,
                  style: _montserrat(14, FontWeight.w700, lineHeightPx: 21.7),
                ),
                TextSpan(
                  text: rest,
                  style: _montserrat(14, restWeight, lineHeightPx: 21.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Notification card (Figma 439:6028)
// ═══════════════════════════════════════════════════════════════════════

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.onAllow});

  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 15, 0, 15),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomPaint(size: Size(24, 24), painter: _BellPainter()),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 21.7,
                      child: Text(
                        'Stay on schedule',
                        style: _montserrat(14, FontWeight.w500,
                            lineHeightPx: 21.7),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Allow notifications for lecture reminders and processing updates.',
                      style: _montserrat(12, FontWeight.w500,
                          lineHeightPx: 17, color: _white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 17),
              child: _AllowButton(onTap: onAllow),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllowButton extends StatelessWidget {
  const _AllowButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: LernoColors.coral,
        borderRadius: BorderRadius.circular(60),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
            child: Text(
              'Allow',
              style: _montserrat(16, FontWeight.w600,
                  color: LernoColors.plumDeep, lineHeightPx: 23.25),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma "bell": coral 1.5px strokes on a 24 × 24 canvas.
class _BellPainter extends CustomPainter {
  const _BellPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = _stroke(LernoColors.coral, 1.5);

    final clapper = Path()
      ..moveTo(16.000, 18.000)
      ..cubicTo(16.000, 20.209, 14.209, 22.000, 12.000, 22.000)
      ..cubicTo(9.791, 22.000, 8.000, 20.209, 8.000, 18.000);
    final dome = Path()
      ..moveTo(4.434, 18.000)
      ..lineTo(19.560, 18.000)
      ..cubicTo(20.288, 18.000, 20.652, 18.000, 20.863, 17.895)
      ..cubicTo(21.272, 17.691, 21.491, 17.236, 21.394, 16.789)
      ..cubicTo(21.345, 16.559, 21.117, 16.275, 20.663, 15.707)
      ..lineTo(20.493, 15.494)
      ..cubicTo(20.037, 14.925, 19.809, 14.640, 19.616, 14.341)
      ..cubicTo(19.017, 13.412, 18.646, 12.354, 18.534, 11.254)
      ..cubicTo(18.497, 10.900, 18.497, 10.535, 18.497, 9.806)
      ..lineTo(18.497, 8.500)
      ..cubicTo(18.497, 8.036, 18.497, 7.804, 18.485, 7.608)
      ..cubicTo(18.288, 4.603, 15.894, 2.210, 12.890, 2.013)
      ..cubicTo(12.694, 2.000, 12.462, 2.000, 11.997, 2.000)
      ..cubicTo(11.533, 2.000, 11.301, 2.000, 11.105, 2.013)
      ..cubicTo(8.101, 2.210, 5.707, 4.603, 5.510, 7.608)
      ..cubicTo(5.497, 7.804, 5.497, 8.036, 5.497, 8.500)
      ..lineTo(5.497, 9.806)
      ..cubicTo(5.497, 10.535, 5.497, 10.900, 5.461, 11.254)
      ..cubicTo(5.349, 12.354, 4.978, 13.412, 4.379, 14.341)
      ..cubicTo(4.186, 14.640, 3.958, 14.925, 3.502, 15.494)
      ..lineTo(3.332, 15.707)
      ..cubicTo(2.878, 16.275, 2.650, 16.559, 2.601, 16.789)
      ..cubicTo(2.504, 17.236, 2.723, 17.691, 3.132, 17.895)
      ..cubicTo(3.343, 18.000, 3.707, 18.000, 4.434, 18.000)
      ..close();

    canvas.drawPath(clapper, paint);
    canvas.drawPath(dome, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
