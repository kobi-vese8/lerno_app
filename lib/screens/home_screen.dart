import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_bottom_nav.dart';
import '../widgets/lerno_icons.dart';
import '../widgets/lerno_search_field.dart';

/// Home / dashboard — built 1:1 from Figma frame
/// "iPhone 16 & 17 Pro - 18" (node 458:6196, 402 × 874).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Stack(
        children: [
          // Ellipse 13 — coral glow centred 220px below the screen.
          const Positioned.fill(
            child: CoralGlow(anchor: GlowAnchor.bottom, edgeOffset: 220),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              // Figma y 71 on an iPhone 16 Pro (62pt status bar).
              top: top + 9,
              bottom: LernoBottomNav.reservedHeight(context) + 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Figma (20, 71).
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 21),
                  child: _GreetingRow(
                    date: _formatDate(now),
                    greeting: '${_greetingFor(now)}, Maya',
                    onAvatarTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                ),
                const SizedBox(height: 12.95),

                // Figma (20, 137).
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LernoSearchField(),
                ),
                const SizedBox(height: 31),

                // Figma (21, 216) — 361 × 293.
                Padding(
                  padding: const EdgeInsets.only(left: 21, right: 20),
                  child: _FeaturedLectureCard(
                    onReview: () =>
                        Navigator.pushNamed(context, '/lecture-detail'),
                  ),
                ),
                const SizedBox(height: 36),

                // Figma (20, 545).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Topic', style: _montserrat(12, FontWeight.w500, lineHeightPx: 12)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/reminders'),
                        behavior: HitTestBehavior.opaque,
                        child: Text('See schedule',
                            style: _montserrat(12, FontWeight.w500,
                                lineHeightPx: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Figma (20, 571) — 15px gaps.
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _ScheduleCard(
                        time: '11:00',
                        duration: '50 min',
                        label: 'NEXT LECTURE',
                        course: 'Discrete Mathematics',
                        building: 'Queen’s Building',
                        room: 'Room 1.15',
                      ),
                      SizedBox(height: 15),
                      _ScheduleCard(
                        time: '11:00',
                        duration: '50 min',
                        label: 'NEXT LECTURE',
                        course: 'Discrete Mathematics',
                        building: 'Queen’s Building',
                        room: 'Room 1.15',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const LernoBottomNav(current: LernoTab.home),
        ],
      ),
    );
  }

  static const _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];
  static const _months = [
    'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY',
    'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
  ];

  static String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';

  static String _greetingFor(DateTime d) {
    if (d.hour < 12) return 'Good Morning';
    if (d.hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Typography
// ═══════════════════════════════════════════════════════════════════════

const Color _white70 = Color(0xB3FFFFFF);
const Color _wine = Color(0xFF681F35);

TextStyle _montserrat(
  double size,
  FontWeight weight, {
  Color color = LernoColors.white,
  double? lineHeightPx,
  double? letterSpacing,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeightPx == null ? null : lineHeightPx / size,
    letterSpacing: letterSpacing,
  );
}

// ═══════════════════════════════════════════════════════════════════════
// Greeting row (Figma 458:6222)
// ═══════════════════════════════════════════════════════════════════════

class _GreetingRow extends StatelessWidget {
  const _GreetingRow({
    required this.date,
    required this.greeting,
    required this.onAvatarTap,
  });

  final String date;
  final String greeting;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 23.25,
                child: Text(
                  date,
                  style: _montserrat(12, FontWeight.w700,
                      color: _white70, lineHeightPx: 23.25),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -8),
                child: SizedBox(
                  height: 37.8,
                  child: Text(
                    greeting,
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
              ),
            ],
          ),
        ),
        const SizedBox(width: 26),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Semantics(
            button: true,
            label: 'Profile',
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4ED),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/home/avatar_maya.png',
                  width: 25.667,
                  height: 28,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Featured lecture card (Figma 462:6255) — pinned coral note, 293 tall
// ═══════════════════════════════════════════════════════════════════════

class _FeaturedLectureCard extends StatelessWidget {
  const _FeaturedLectureCard({required this.onReview});

  final VoidCallback onReview;

  static const _height = 293.0;

  @override
  Widget build(BuildContext context) {
    final pin = Positioned(
      left: -19.09,
      top: -24.344,
      child: Transform.flip(
        flipX: true,
        child: Image.asset(
          'assets/welcome/pushpin.png',
          width: 57.342,
          height: 57.342,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.high,
        ),
      ),
    );

    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final shape = Positioned.fill(
            child: CustomPaint(painter: _CardBodyPainter(w)),
          );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Drop shadow 0 / 36.1, blur 28.9 @ 25% of the note + pin.
              Positioned.fill(
                child: Transform.translate(
                  offset: const Offset(0, 36.1),
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(
                      sigmaX: 14.44,
                      sigmaY: 14.44,
                      tileMode: TileMode.decal,
                    ),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Color(0x40000000), BlendMode.srcIn),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [shape, pin],
                      ),
                    ),
                  ),
                ),
              ),
              shape,
              Positioned.fill(
                child: CustomPaint(painter: _FlapPainter(w)),
              ),

              // Pin-hole shadow.
              Positioned(
                left: 0,
                top: 0,
                child: Transform(
                  transform: Matrix4(
                    0.944, 0.331, 0, 0, //
                    -0.331, 0.944, 0, 0, //
                    0, 0, 1, 0, //
                    21.501, 19.56, 0, 1, //
                  ),
                  child: ImageFiltered(
                    imageFilter:
                        ui.ImageFilter.blur(sigmaX: 1.786, sigmaY: 1.786),
                    child: const SizedBox(
                      width: 5,
                      height: 5.714,
                      child: ColoredBox(color: Colors.black),
                    ),
                  ),
                ),
              ),
              pin,

              // Content block at (22, 42.93), 316.8 wide on a 361 card.
              Positioned(
                left: 22,
                right: w - 22 - 316.809 < 0 ? 0 : w - 22 - 316.809,
                top: 42.934,
                child: _CardContent(onReview: onReview),
              ),

              // bookmark-02 sitting on the folded corner.
              Positioned(
                left: w - 54,
                top: 43,
                child: const LernoIcon(
                  LernoGlyphs.bookmark,
                  color: LernoColors.plumDeep,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Coral body: three corners rounded 21.66, top-right corner cut
/// diagonally (65 × 75.9) for the fold.
class _CardBodyPainter extends CustomPainter {
  const _CardBodyPainter(this.w);

  final double w;

  @override
  void paint(Canvas canvas, Size size) {
    const r = 21.66, h = 293.0;
    const radius = Radius.circular(r);
    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(w - 65, 0)
      ..lineTo(w, 75.887)
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: radius)
      ..lineTo(r, h)
      ..arcToPoint(const Offset(0, h - r), radius: radius)
      ..lineTo(0, r)
      ..arcToPoint(const Offset(r, 0), radius: radius)
      ..close();
    canvas.drawPath(path, Paint()..color = LernoColors.admin);
  }

  @override
  bool shouldRepaint(covariant _CardBodyPainter old) => old.w != w;
}

/// Folded flap (Polygon 1): 66 × 78.4 with its inner corner rounded 21.66,
/// coral gradient and a 1.4px side shadow.
class _FlapPainter extends CustomPainter {
  const _FlapPainter(this.w);

  final double w;

  @override
  void paint(Canvas canvas, Size size) {
    const r = 21.66, fh = 78.434;
    final x0 = w - 65; // 296 on a 361 card
    final path = Path()
      ..moveTo(x0, 0)
      ..lineTo(x0, fh - r)
      ..arcToPoint(Offset(x0 + r, fh),
          radius: const Radius.circular(r), clockwise: false)
      ..lineTo(w + 1, fh)
      ..close();

    canvas.drawPath(
      path.shift(const Offset(1.444, 0)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.444),
    );
    final dx = w - 361;
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(267.098 + dx, 93.123),
          Offset(339.683 + dx, 26.658),
          const [Color(0xFFFF5858), Color(0xFFDC4B4B)],
          const [0, 0.657],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _FlapPainter old) => old.w != w;
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.onReview});

  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final dmSansBold = GoogleFonts.dmSans(fontWeight: FontWeight.w700);
    final meta = _montserrat(12, FontWeight.w600,
        color: LernoColors.plumDeep, lineHeightPx: 15, letterSpacing: 0.8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "READY TO REVIEW" badge — plum 20%, radius 99.
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: const Color(0x333D001F),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: LernoColors.plumDeep,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'READY TO REVIEW',
                style: dmSansBold.copyWith(
                  fontSize: 12,
                  height: 1,
                  letterSpacing: 0.64,
                  color: LernoColors.plumDeep,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 12,
          child: Text(
            'INTRODUCTION TO COMPUTER SCIENCE',
            maxLines: 1,
            style: _montserrat(10, FontWeight.w600,
                color: LernoColors.plumDeep,
                lineHeightPx: 12,
                letterSpacing: 0.8),
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 56,
          child: Text(
            'Functions, Recursion &\nProblem Solving',
            style: GoogleFonts.museoModerno(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              height: 28 / 25,
              color: LernoColors.plumDeep,
            ),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 20,
          child: Row(
            children: [
              const LernoIcon(LernoGlyphs.clock, color: LernoColors.plumDeep),
              const SizedBox(width: 4),
              Text('48 min', style: meta),
              const SizedBox(width: 18),
              Text('5 key concepts', style: meta),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // White pill button, min height 50, radius 40.
        SizedBox(
          height: 50,
          width: double.infinity,
          child: Material(
            color: LernoColors.white,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              onTap: onReview,
              borderRadius: BorderRadius.circular(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LernoIcon(LernoGlyphs.play, color: _wine),
                  const SizedBox(width: 9),
                  Text(
                    'Review latest lecture',
                    style: dmSansBold.copyWith(
                      fontSize: 16,
                      height: 24 / 16,
                      color: _wine,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Schedule card (Figma 522:6446) — 362 × 88
// ═══════════════════════════════════════════════════════════════════════

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.time,
    required this.duration,
    required this.label,
    required this.course,
    required this.building,
    required this.room,
  });

  final String time;
  final String duration;
  final String label;
  final String course;
  final String building;
  final String room;

  @override
  Widget build(BuildContext context) {
    final light = _montserrat(12, FontWeight.w300, lineHeightPx: 21.7);

    return Container(
      height: 88,
      padding: const EdgeInsets.all(9), // +1px border = 10, as in Figma
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x33FD5454), width: 1),
      ),
      child: Row(
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Time column, 42 wide.
                SizedBox(
                  width: 42,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(time,
                          textAlign: TextAlign.center,
                          style: _montserrat(12, FontWeight.w600,
                              lineHeightPx: 21.7)),
                      Text(duration,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: _montserrat(12, FontWeight.w300,
                              color: _white70, lineHeightPx: 21.7)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 1, height: 50, color: const Color(0x33FD5454)),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: _montserrat(12, FontWeight.w400,
                              lineHeightPx: 21.7)),
                      Text(course,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _montserrat(12, FontWeight.w600,
                              lineHeightPx: 21.7)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const LernoIcon(LernoGlyphs.location,
                              color: _white70),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(building,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: light),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 2,
                            height: 2,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(room, style: light),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 55),
          // Reminder bell: deep-plum circle, 6px padding.
          Semantics(
            button: true,
            label: 'Set reminder',
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: LernoColors.plumDeep,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: const LernoIcon(LernoGlyphs.bellSmall,
                    color: LernoColors.coral),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
