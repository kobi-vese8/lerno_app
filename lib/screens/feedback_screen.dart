import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/lerno_icons.dart';
import '../widgets/lerno_pill_button.dart';

/// Confidential feedback — built 1:1 from Figma frame
/// "iPhone 16 & 17 Pro - 29" (node 675:623, 402 × 874). Offsets assume a
/// 62pt status bar. The frame has no background glow.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _lectures = [
    'Functions, Recursion & Problem Solving',
    'Discrete Mathematics: Proof by Induction',
    'Set Theory Basics',
    'Data Types & Variables',
  ];

  /// Category → rating question options. Figma shows Pace; the others
  /// follow the same "low / right / high" pattern.
  static const _ratings = {
    'Content': ['Too basic', 'Just right', 'Too advanced'],
    'Pace': ['Too slow', 'Just right', 'Too fast'],
    'Clarity': ['Unclear', 'Mostly clear', 'Very clear'],
    'Engagement': ['Low', 'Okay', 'High'],
    'Materials': ['Not helpful', 'Okay', 'Very helpful'],
  };

  final _comments = TextEditingController();
  String _lecture = _lectures.first;
  String _category = 'Pace';
  final Map<String, String> _answers = {'Pace': 'Just right'};

  @override
  void dispose() {
    _comments.dispose();
    super.dispose();
  }

  Future<void> _pickLecture() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF2A0016),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final lecture in _lectures)
                ListTile(
                  onTap: () => Navigator.pop(context, lecture),
                  title: Text(
                    lecture,
                    style: _montserrat(
                      14,
                      lecture == _lecture ? FontWeight.w600 : FontWeight.w500,
                      color: lecture == _lecture
                          ? LernoColors.coral
                          : LernoColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _lecture = picked);
  }

  void _submit() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).maybePop();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: LernoColors.coral,
        content: Text(
          'Feedback sent anonymously',
          style: _montserrat(13, FontWeight.w600,
              color: LernoColors.plumDeep),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    final options = _ratings[_category]!;

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Column(
        children: [
          // Figma y 0 → 140: back button (y 78) + title (y 86).
          SizedBox(
            height: top + 78,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  top: top + 16,
                  child: _GlassBackButton(
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                Positioned(
                  left: 80,
                  right: 20,
                  top: top + 24,
                  child: Text(
                    'Confidential Feedback',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.museoModerno(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9,
                      color: LernoColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _AnonymityNotice(),
                  ),
                  // y 200 → label 220 → field 246.
                  const SizedBox(height: 20),
                  const _FieldLabel('Select lecture'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _LectureDropdown(
                      value: _lecture,
                      onTap: _pickLecture,
                    ),
                  ),
                  // y 296 → 316 → chips 342.
                  const SizedBox(height: 20),
                  const _FieldLabel('Category'),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _ratings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final category = _ratings.keys.elementAt(i);
                        return _CategoryChip(
                          label: category,
                          selected: category == _category,
                          onTap: () => setState(() => _category = category),
                        );
                      },
                    ),
                  ),
                  // y 374 → 400 → options 430.
                  const SizedBox(height: 26),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'How was the ${_category.toLowerCase()}?',
                        style: _montserrat(14, FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        for (var i = 0; i < options.length; i++) ...[
                          if (i > 0) const SizedBox(width: 7),
                          Expanded(
                            child: _RatingOption(
                              label: options[i],
                              selected: _answers[_category] == options[i],
                              onTap: () => setState(
                                  () => _answers[_category] = options[i]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // y 470 → 500 → comments 526.
                  const SizedBox(height: 30),
                  const _FieldLabel('Additional comments'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _CommentsField(controller: _comments),
                  ),
                ],
              ),
            ),
          ),
          // Figma: 342 × 54 pill at x 30, 50px above the bottom edge.
          Padding(
            padding:
                EdgeInsets.fromLTRB(30, 0, 30, math.max(50.0, bottom + 16)),
            child: LernoPillButton(label: 'Review feedback', onPressed: _submit),
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
  double? lineHeightPx,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: lineHeightPx == null ? null : lineHeightPx / size,
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

/// White 8% box (radius 12, min 60 tall): lock at (12, 12) and Light 12 /
/// 18px white-60% text at x 36.
class _AnonymityNotice extends StatelessWidget {
  const _AnonymityNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LernoIcon(LernoGlyphs.lock, color: Color(0x99FFFFFF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your feedback is completely anonymous.\nLecturers cannot identify you.',
              style: _montserrat(12, FontWeight.w300,
                  color: const Color(0x99FFFFFF), lineHeightPx: 18),
            ),
          ),
        ],
      ),
    );
  }
}

/// Medium 14 white label; the field starts 26px below its top.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(text, style: _montserrat(14, FontWeight.w500)),
      ),
    );
  }
}

/// Outlined pill (50 tall, radius 30, 1px coral-20% border) with a chevron.
class _LectureDropdown extends StatelessWidget {
  const _LectureDropdown({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: const BorderSide(color: Color(0x33FD5454)),
    );
    return Material(
      type: MaterialType.transparency,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 19, right: 17),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _montserrat(14, FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                const LernoIcon(LernoGlyphs.chevronDown,
                    color: Color(0x80FFFFFF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 32px pill: white 12% / Medium white, or coral / SemiBold plum.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? LernoColors.coral : const Color(0x1FFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: _montserrat(
              12,
              selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? LernoColors.plumDeep : LernoColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// 40px option: white 8% / Medium white, or coral 15% with a coral-50%
/// border and SemiBold coral label when selected.
class _RatingOption extends StatelessWidget {
  const _RatingOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0x26FD5454) : const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0x80FD5454) : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _montserrat(
              12,
              selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? LernoColors.coral : LernoColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// White 8% box (120 tall, radius 16, 1px coral-15% border) with a Light
/// 13 / 20px text field 15px from the outer edge.
class _CommentsField extends StatelessWidget {
  const _CommentsField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final style = _montserrat(13, FontWeight.w300, lineHeightPx: 20);
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x26FD5454)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        keyboardType: TextInputType.multiline,
        style: style,
        cursorColor: LernoColors.coral,
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText:
              'Share your thoughts on how the lecture could be improved...',
          hintMaxLines: 3,
          hintStyle: style.copyWith(color: const Color(0x66FFFFFF)),
        ),
      ),
    );
  }
}
