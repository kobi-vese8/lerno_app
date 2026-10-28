import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_pill_button.dart';
import '../widgets/onboarding_app_bar.dart';

/// Onboarding step 1 — built 1:1 from Figma frame
/// "iPhone 16 & 17 Pro - 13" (node 258:7376, 402 × 874).
class OnboardingStudiesScreen extends StatefulWidget {
  const OnboardingStudiesScreen({super.key});

  @override
  State<OnboardingStudiesScreen> createState() =>
      _OnboardingStudiesScreenState();
}

class _OnboardingStudiesScreenState extends State<OnboardingStudiesScreen> {
  static const _institutions = [
    'Veritas University',
    'University of Lagos',
    'Covenant University',
  ];
  static const _programmes = [
    'Bsc. Software Engineering',
    'Bsc. Computer Science',
    'Bsc. Information Technology',
  ];

  String? _institution;
  String? _programme;
  int _year = 1;

  Future<void> _pick({
    required String title,
    required List<String> options,
    required String? current,
    required ValueChanged<String> onSelected,
  }) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: LernoColors.plumDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _OptionSheet(
        title: title,
        options: options,
        current: current,
      ),
    );
    if (choice != null) onSelected(choice);
  }

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
                title: 'Tell us about your studies',
                step: 1,
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      // Figma (20, 178) — Montserrat Light 14 / 21.7.
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 353),
                          child: Text(
                            'We’ll use this to organise your lectures and tailor study tools.',
                            style: _montserrat(14, FontWeight.w300,
                                lineHeightPx: 21.7, color: _white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.6),

                      // Figma (19, 252).
                      Padding(
                        padding: const EdgeInsets.only(left: 19, right: 20.4),
                        child: _FieldGroup(
                          label: 'Institution',
                          labelSize: 12,
                          child: _SelectField(
                            value: _institution,
                            hint: 'Select your institution',
                            radius: 30,
                            onTap: () => _pick(
                              title: 'Institution',
                              options: _institutions,
                              current: _institution,
                              onSelected: (v) =>
                                  setState(() => _institution = v),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Figma (19, 366).
                      Padding(
                        padding: const EdgeInsets.only(left: 19, right: 20.4),
                        child: _FieldGroup(
                          label: 'Programme',
                          labelSize: 12,
                          child: _SelectField(
                            value: _programme,
                            hint: 'Select your programme',
                            radius: 38,
                            onTap: () => _pick(
                              title: 'Programme',
                              options: _programmes,
                              current: _programme,
                              onSelected: (v) =>
                                  setState(() => _programme = v),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Figma (20, 480).
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 21.5),
                        child: _FieldGroup(
                          label: 'Year of Study',
                          labelSize: 14,
                          child: _YearSelector(
                            selected: _year,
                            onChanged: (y) => setState(() => _year = y),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),

                      // Figma (21, 594) — 361 × 88.
                      const Padding(
                        padding: EdgeInsets.only(left: 21, right: 20),
                        child: _StudyPreferenceCard(),
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
                  label: 'Continue',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/onboarding/courses'),
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
// Typography
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

// ═══════════════════════════════════════════════════════════════════════
// Field group: label (21.7 tall) + 8.3 gap + control
// ═══════════════════════════════════════════════════════════════════════

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({
    required this.label,
    required this.labelSize,
    required this.child,
  });

  final String label;
  final double labelSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 21.7,
          child: Text(
            label,
            style: _montserrat(labelSize, FontWeight.w500, lineHeightPx: 21.7),
          ),
        ),
        const SizedBox(height: 8.3),
        child,
      ],
    );
  }
}

/// Outlined pill (coral 20% stroke) showing the selected value and a thin
/// down chevron. Opens a bottom-sheet picker.
class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.value,
    required this.hint,
    required this.radius,
    required this.onTap,
  });

  final String? value;
  final String hint;
  final double radius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: 54,
          // +1px border on each side → text at 20, chevron 39 from the right.
          padding: const EdgeInsets.only(left: 19, right: 38),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0x33FD5454), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(
                    14,
                    FontWeight.w500,
                    lineHeightPx: 23.25,
                    color: hasValue ? LernoColors.white : const Color(0x80FFFFFF),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const CustomPaint(
                size: Size(12.632, 6.316),
                painter: _DownChevronPainter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownChevronPainter extends CustomPainter {
  const _DownChevronPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Figma vector 258:7485 rotated −90°, stroke 1.58, round caps.
    final path = Path()
      ..moveTo(0, 0)
      ..cubicTo(0, 0, 4.651, 6.316, 6.316, 6.316)
      ..cubicTo(7.980, 6.316, 12.632, 0, 12.632, 0);
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

class _OptionSheet extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.options,
    required this.current,
  });

  final String title;
  final List<String> options;
  final String? current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.museoModerno(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: LernoColors.white,
              ),
            ),
            const SizedBox(height: 8),
            for (final option in options)
              InkWell(
                onTap: () => Navigator.pop(context, option),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: _montserrat(14, FontWeight.w500,
                              lineHeightPx: 23.25),
                        ),
                      ),
                      if (option == current)
                        const Icon(Icons.check_rounded,
                            color: LernoColors.coral, size: 20),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Year of Study segmented control (Figma 258:7518, 360.5 × 50)
// ═══════════════════════════════════════════════════════════════════════

class _YearSelector extends StatelessWidget {
  const _YearSelector({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const _labels = ['1', '2', '3', '4+'];

  /// Segment widths in Figma are 83 / 87 / 87 / 99.5 (38px padding around
  /// each label); used as flex weights so the control still fits narrower
  /// phones.
  static const _flex = [166, 174, 174, 199];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++)
            Expanded(
              flex: _flex[i],
              child: Semantics(
                button: true,
                selected: selected == i + 1,
                label: 'Year ${_labels[i]}',
                child: GestureDetector(
                  onTap: () => onChanged(i + 1),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected == i + 1
                          ? LernoColors.coral
                          : const Color(0x00FD5454),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: selected == i + 1
                          ? const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          offset: Offset(0, 2),
                          blurRadius: 5,
                        ),
                      ]
                          : null,
                    ),
                    child: Text(
                      _labels[i],
                      style: _montserrat(
                        18,
                        FontWeight.w600,
                        lineHeightPx: 23.25,
                        color: selected == i + 1
                            ? LernoColors.plumDeep
                            : LernoColors.white,
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

// ═══════════════════════════════════════════════════════════════════════
// Study preference card (Figma 294:7558)
// ═══════════════════════════════════════════════════════════════════════

class _StudyPreferenceCard extends StatelessWidget {
  const _StudyPreferenceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 15, 0, 15),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomPaint(
            size: Size(24, 24),
            painter: _SparklePainter(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 21.7,
                  child: Text(
                    'Study Preference',
                    style: _montserrat(14, FontWeight.w500, lineHeightPx: 21.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'We’ll start with concise summaries. you can \nchange this any time.',
                  style: _montserrat(12, FontWeight.w500,
                      lineHeightPx: 17, color: _white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma "ai-magic" icon: coral 1.5px stroked four-point star + small
/// twinkle, on a 24 × 24 canvas.
class _SparklePainter extends CustomPainter {
  const _SparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = LernoColors.coral;

    final star = Path()
      ..moveTo(13.427, 8.084)
      ..cubicTo(12.801, 5.843, 12.323, 4.000, 11.000, 4.000)
      ..cubicTo(9.678, 4.000, 9.200, 5.843, 8.573, 8.084)
      ..cubicTo(8.319, 8.995, 8.191, 9.450, 7.820, 9.821)
      ..cubicTo(7.450, 10.192, 6.994, 10.319, 6.084, 10.573)
      ..cubicTo(3.843, 11.200, 2.000, 11.678, 2.000, 13.000)
      ..cubicTo(2.000, 14.322, 3.843, 14.800, 6.084, 15.427)
      ..cubicTo(6.994, 15.681, 7.450, 15.808, 7.820, 16.179)
      ..cubicTo(8.191, 16.550, 8.319, 17.005, 8.573, 17.916)
      ..cubicTo(9.200, 20.157, 9.678, 22.000, 11.000, 22.000)
      ..cubicTo(12.323, 22.000, 12.801, 20.157, 13.427, 17.916)
      ..cubicTo(13.682, 17.005, 13.809, 16.550, 14.179, 16.179)
      ..cubicTo(14.550, 15.809, 15.006, 15.681, 15.916, 15.427)
      ..cubicTo(18.157, 14.800, 20.000, 14.322, 20.000, 13.000)
      ..cubicTo(20.000, 11.678, 18.157, 11.200, 15.916, 10.573)
      ..cubicTo(15.006, 10.319, 14.550, 10.191, 14.179, 9.821)
      ..cubicTo(13.809, 9.450, 13.682, 8.995, 13.427, 8.084)
      ..close();

    final twinkle = Path()
      ..moveTo(19.500, 2.938)
      ..lineTo(19.500, 4.500)
      ..moveTo(19.500, 4.500)
      ..lineTo(19.500, 6.062)
      ..moveTo(19.500, 4.500)
      ..lineTo(18.250, 4.500)
      ..moveTo(19.500, 4.500)
      ..lineTo(20.750, 4.500)
      ..moveTo(22.000, 4.500)
      ..lineTo(21.548, 4.349)
      ..cubicTo(20.850, 4.117, 20.501, 4.000, 20.250, 3.750)
      ..cubicTo(20.000, 3.499, 19.883, 3.150, 19.651, 2.452)
      ..lineTo(19.500, 2.000)
      ..lineTo(19.349, 2.452)
      ..cubicTo(19.117, 3.150, 19.000, 3.499, 18.750, 3.750)
      ..cubicTo(18.499, 4.000, 18.150, 4.117, 17.452, 4.349)
      ..lineTo(17.000, 4.500)
      ..lineTo(17.452, 4.651)
      ..cubicTo(18.150, 4.883, 18.499, 5.000, 18.750, 5.250)
      ..cubicTo(19.000, 5.501, 19.117, 5.850, 19.349, 6.548)
      ..lineTo(19.500, 7.000)
      ..lineTo(19.651, 6.548)
      ..cubicTo(19.883, 5.850, 20.000, 5.501, 20.250, 5.250)
      ..cubicTo(20.501, 5.000, 20.850, 4.883, 21.548, 4.651)
      ..lineTo(22.000, 4.500)
      ..close();

    canvas.drawPath(star, paint);
    canvas.drawPath(twinkle, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}