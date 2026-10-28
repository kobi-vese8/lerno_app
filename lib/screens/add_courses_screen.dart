import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_search_field.dart';
import '../widgets/lerno_pill_button.dart';
import '../widgets/onboarding_app_bar.dart';

/// Onboarding step 2 — built 1:1 from Figma frame
/// "iPhone 16 & 17 Pro - 15" (node 358:1628, 402 × 874).
class AddCoursesScreen extends StatefulWidget {
  const AddCoursesScreen({super.key});

  @override
  State<AddCoursesScreen> createState() => _AddCoursesScreenState();
}

class _AddCoursesScreenState extends State<AddCoursesScreen> {
  final _searchController = TextEditingController();
  final _codeController = TextEditingController();
  final Set<String> _addedCourses = {};
  String _query = '';

  static const _suggestedCourses = [
    _Course(
      abbr: 'CS',
      background: Color(0xFF3B2431),
      foreground: Color(0xFFF4CFE1),
      name: 'Introduction to computer science',
      code: 'COMS1001',
      semester: '1st Semester',
    ),
    _Course(
      abbr: 'DM',
      background: Color(0xFF00C8B3),
      foreground: Color(0xFF003732),
      name: 'Discrete Mathematics',
      code: 'MATH1004',
      semester: '1st Semester',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  List<_Course> get _visibleCourses {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _suggestedCourses;
    return _suggestedCourses
        .where((c) =>
    c.name.toLowerCase().contains(q) ||
        c.code.toLowerCase().contains(q))
        .toList();
  }

  void _toggle(_Course course) {
    setState(() {
      if (!_addedCourses.remove(course.code)) _addedCourses.add(course.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final courses = _visibleCourses;
    final added = _addedCourses.length;

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
                title: 'Add your courses',
                step: 2,
                progressOpacity: 0.8,
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 29),

                      // Figma (20, 177) — 362 × 48.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LernoSearchField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                      const SizedBox(height: 42),

                      // Figma (20, 267).
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          height: 21.7,
                          child: Text(
                            'Suggested for your program',
                            style: _montserrat(12, FontWeight.w500,
                                lineHeightPx: 21.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18.3),

                      // Figma (20, 307) — 362 wide.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            for (var i = 0; i < courses.length; i++)
                              _CourseRow(
                                course: courses[i],
                                isFirst: i == 0,
                                isAdded:
                                _addedCourses.contains(courses[i].code),
                                onToggle: () => _toggle(courses[i]),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Figma (centre +1, 484).
                      const Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: _OrDivider(),
                      ),
                      const SizedBox(height: 30.3),

                      // Figma (19, 536) — 363 wide.
                      Padding(
                        padding: const EdgeInsets.only(left: 19, right: 20),
                        child: _CourseCodeField(
                          controller: _codeController,
                          onJoin: () => FocusScope.of(context).unfocus(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Figma (30, 770) — pinned 50px above the bottom edge.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: LernoPillButton(
                  label: added == 0
                      ? 'Continue with courses'
                      : 'Continue with $added ${added == 1 ? 'course' : 'courses'}',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/onboarding/complete'),
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
// Typography & tokens
// ═══════════════════════════════════════════════════════════════════════

const Color _coral20 = Color(0x33FD5454);

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

Paint _stroke(Color color, double width) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..color = color;

// ═══════════════════════════════════════════════════════════════════════
// Suggested course rows (Figma 369:1785 / 369:1786)
// ═══════════════════════════════════════════════════════════════════════

class _CourseRow extends StatelessWidget {
  const _CourseRow({
    required this.course,
    required this.isFirst,
    required this.isAdded,
    required this.onToggle,
  });

  final _Course course;
  final bool isFirst;
  final bool isAdded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: isFirst ? 0 : 15, bottom: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _coral20, width: 1)),
      ),
      child: Row(
        children: [
          _CourseAvatar(course: course),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(
                    14,
                    isAdded ? FontWeight.w700 : FontWeight.w500,
                    lineHeightPx: 21.7,
                  ),
                ),
                Row(
                  children: [
                    Text(course.code,
                        style: _montserrat(12, FontWeight.w300,
                            lineHeightPx: 21.7)),
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
                    Text(course.semester,
                        style: _montserrat(12, FontWeight.w300,
                            lineHeightPx: 21.7)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10 + 23),
          _AddButton(isAdded: isAdded, onTap: onToggle),
        ],
      ),
    );
  }
}

/// 50px circle with Kufam SemiBold initials.
class _CourseAvatar extends StatelessWidget {
  const _CourseAvatar({required this.course});

  final _Course course;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: course.background,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // Figma text box: 19px from the top, centred horizontally.
          Positioned(
            left: 0,
            right: 0,
            top: 19,
            child: MediaQuery.withNoTextScaling(
              child: Text(
                course.abbr,
                textAlign: TextAlign.center,
                style: GoogleFonts.kufam(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 18.72 / 20,
                  color: course.foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma "add button": 30px circle, 0.83px coral-20% outline, coral plus.
/// Added state fills the circle and swaps the plus for a check.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.isAdded, required this.onTap});

  final bool isAdded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: isAdded,
      label: isAdded ? 'Remove course' : 'Add course',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAdded ? LernoColors.coral : const Color(0x00FD5454),
            border: Border.all(
              color: isAdded ? LernoColors.coral : _coral20,
              width: 0.833,
            ),
          ),
          child: Center(
            child: CustomPaint(
              size: const Size(20, 20),
              painter: _AddIconPainter(added: isAdded),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddIconPainter extends CustomPainter {
  const _AddIconPainter({required this.added});

  final bool added;

  @override
  void paint(Canvas canvas, Size size) {
    if (added) {
      final paint = _stroke(LernoColors.plumDeep, 1.6);
      canvas.drawPath(
        Path()
          ..moveTo(5.5, 10.3)
          ..lineTo(8.6, 13.3)
          ..lineTo(14.5, 7.0),
        paint,
      );
      return;
    }
    // Figma "add-01": two 11.67px strokes, 1.25 wide.
    final paint = _stroke(LernoColors.coral, 1.25);
    canvas.drawLine(const Offset(10, 4.167), const Offset(10, 15.835), paint);
    canvas.drawLine(
        const Offset(15.835, 10.002), const Offset(4.167, 10.002), paint);
  }

  @override
  bool shouldRepaint(covariant _AddIconPainter old) => old.added != added;
}

// ═══════════════════════════════════════════════════════════════════════
// "or Join with a code" divider (Figma 374:1822)
// ═══════════════════════════════════════════════════════════════════════

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    Widget line() => Flexible(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        height: 1,
        color: _coral20,
      ),
    );

    return SizedBox(
      height: 21.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line(),
          const SizedBox(width: 15),
          Text('or Join with a code',
              style: _montserrat(12, FontWeight.w300, lineHeightPx: 21.7)),
          const SizedBox(width: 15),
          line(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Course code input with inline Join pill (Figma 392:3212)
// ═══════════════════════════════════════════════════════════════════════

class _CourseCodeField extends StatelessWidget {
  const _CourseCodeField({required this.controller, required this.onJoin});

  final TextEditingController controller;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final inputStyle = _montserrat(16, FontWeight.w500, lineHeightPx: 23.25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 21.7,
          child: Text('Course code',
              style: _montserrat(12, FontWeight.w500, lineHeightPx: 21.7)),
        ),
        const SizedBox(height: 8),
        Container(
          // +1px border → 20 left, 2 elsewhere, as in Figma.
          padding: const EdgeInsets.fromLTRB(19, 1, 1, 1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _coral20, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: inputStyle,
                  cursorColor: LernoColors.coral,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onJoin(),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'e.g CS-24-A9',
                    hintStyle: inputStyle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _JoinButton(onTap: onJoin),
            ],
          ),
        ),
      ],
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.onTap});

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
            padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 11),
            child: Text(
              'Join',
              style: _montserrat(16, FontWeight.w600,
                  color: LernoColors.plumDeep, lineHeightPx: 23.25),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Data
// ═══════════════════════════════════════════════════════════════════════

class _Course {
  const _Course({
    required this.abbr,
    required this.background,
    required this.foreground,
    required this.name,
    required this.code,
    required this.semester,
  });

  final String abbr;
  final Color background;
  final Color foreground;
  final String name;
  final String code;
  final String semester;
}