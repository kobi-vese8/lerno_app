import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_icons.dart';
import '../widgets/lerno_pill_button.dart';

/// Study session — spaced-repetition review, built 1:1 from Figma frames
/// "iPhone 16 & 17 Pro - 24" (question, node 666:910) and "- 25" (answer +
/// self-rating, node 666:1001). Offsets assume a 62pt status bar.
class StudySessionScreen extends StatefulWidget {
  const StudySessionScreen({super.key});

  @override
  State<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _Flashcard {
  const _Flashcard({
    required this.question,
    required this.hint,
    required this.answer,
    this.example,
    this.source = 'Intro to CS · Recursion essentials',
  });

  final String question;
  final String hint;
  final List<String> answer;

  /// Lines shown under "Example:".
  final List<String>? example;
  final String source;
}

class _StudySessionScreenState extends State<StudySessionScreen> {
  static const _cards = [
    _Flashcard(
      question:
          'What is the difference between a parameter and an argument in the context of function definitions?',
      hint: 'Think about where each appears in code',
      answer: [
        "A parameter is a variable listed in the function's definition — it acts as a placeholder.",
        'An argument is the actual value passed to the function when it is called.',
      ],
      example: [
        'def greet(name):  ← name is a parameter',
        'greet("Maya")  ← "Maya" is an argument',
      ],
    ),
    _Flashcard(
      question: 'Why does every recursive function need a base case?',
      hint: 'What would happen if the function never stopped calling itself?',
      answer: [
        'The base case is the condition where the function returns without calling itself again.',
        'Without it, the recursion never ends and the call stack overflows.',
      ],
    ),
    _Flashcard(
      question: 'What does the call stack store for each function call?',
      hint: 'Think about what a function needs to resume after a call returns',
      answer: [
        'Each call gets a new stack frame holding its local variables and parameters.',
        'The frame also records the return address, so execution resumes in the right place.',
      ],
    ),
  ];

  int _index = 0;
  bool _showAnswer = false;

  void _reveal() => setState(() => _showAnswer = true);

  void _rate(String rating) {
    if (_index == _cards.length - 1) {
      Navigator.of(context).maybePop(); // Session complete.
      return;
    }
    setState(() {
      _index++;
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    final card = _cards[_index];

    return Scaffold(
      backgroundColor: LernoColors.plumDeep,
      body: Stack(
        children: [
          // Ellipse 13 glows: 390px above (question only) and 200px below.
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _showAnswer ? 0 : 1,
              duration: const Duration(milliseconds: 250),
              child: const CoralGlow(anchor: GlowAnchor.top, edgeOffset: 390),
            ),
          ),
          const Positioned.fill(
            child: CoralGlow(anchor: GlowAnchor.bottom, edgeOffset: 200),
          ),
          Column(
            children: [
              // Figma y 0 → 148: close button, title, progress bar.
              SizedBox(
                height: top + 86,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 20,
                      top: top + 16,
                      child: _GlassCloseButton(
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    Positioned(
                      left: 80,
                      top: top + 24,
                      child: Text(
                        'Study session',
                        style: GoogleFonts.museoModerno(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.9,
                          color: LernoColors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 80,
                      top: top + 50,
                      child: Text(
                        '${_index + 1} of ${_cards.length}',
                        style: _montserrat(12, FontWeight.w500,
                            color: const Color(0xB3FFFFFF)),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top + 82,
                      child: _SessionProgress(
                        progress: (_index + 1) / _cards.length,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 52, 20, math.max(50.0, bottom + 16)),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _showAnswer
                        ? _AnswerView(
                            key: ValueKey('a$_index'),
                            card: card,
                            onRate: _rate,
                          )
                        : _QuestionView(key: ValueKey('q$_index'), card: card),
                  ),
                ),
              ),
              // Figma: 342 × 54 pill at x 30, 50px above the bottom edge.
              // In the answer state the rating sits under the card instead.
              if (!_showAnswer)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      30, 0, 30, math.max(50.0, bottom + 16)),
                  child:
                      LernoPillButton(label: 'Show answer', onPressed: _reveal),
                ),
            ],
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
// Header
// ═══════════════════════════════════════════════════════════════════════

/// 40px frosted circle (white 20%, 0.84px white-30% border) with a 16px ×.
class _GlassCloseButton extends StatelessWidget {
  const _GlassCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close study session',
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
              child: const LernoIcon(LernoGlyphs.close,
                  color: LernoColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width 4px track (white 10%, shadow 0/0.8 blur 12 @ 25%) with a
/// square-ended coral fill that animates between cards.
class _SessionProgress extends StatelessWidget {
  const _SessionProgress({required this.progress});

  final double progress;

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
            blurRadius: 9.5,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: progress),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => FractionallySizedBox(
          widthFactor: value,
          heightFactor: 1,
          child: const ColoredBox(color: LernoColors.coral),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Card states
// ═══════════════════════════════════════════════════════════════════════

/// Coral section label (Figma y 200) — the card starts 30px below it.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Text(
        text,
        style: _montserrat(11, FontWeight.w700,
            color: LernoColors.coral, letterSpacing: 1.5),
      ),
    );
  }
}

/// White 10% card, radius 20, 16px side padding.
class _StudyCard extends StatelessWidget {
  const _StudyCard({required this.child, this.top = 30});

  final Widget child;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

/// Question (Medium 18 / 28), hint (Light 13, white 50%) and source tag.
/// Gaps follow the Figma card: question y 30, hint y 160, tag y 220.
class _QuestionView extends StatelessWidget {
  const _QuestionView({super.key, required this.card});

  final _Flashcard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('QUESTION'),
        _StudyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                // Three 28px lines in Figma; keeps the hint at y 160.
                constraints: const BoxConstraints(minHeight: 84),
                child: Text(
                  card.question,
                  style: _montserrat(18, FontWeight.w500, lineHeightPx: 28),
                ),
              ),
              const SizedBox(height: 46),
              Text(
                card.hint,
                style: _montserrat(13, FontWeight.w300,
                    color: const Color(0x80FFFFFF)),
              ),
              const SizedBox(height: 44),
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0x1FFD5454),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  card.source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(11, FontWeight.w500,
                      color: LernoColors.coral),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Figma frame 25: white 10% card (radius 20, min 300 tall) with Light 14 /
/// 22px text, a blank line between paragraphs, then "How did you do?" 40px
/// below the card and three outlined 70px rating buttons 12px below that.
class _AnswerView extends StatelessWidget {
  const _AnswerView({super.key, required this.card, required this.onRate});

  final _Flashcard card;
  final ValueChanged<String> onRate;

  static const _amber = Color(0xFFFFBF4D);
  static const _green = Color(0xFF4DD980);

  @override
  Widget build(BuildContext context) {
    final example = card.example;
    final body = _montserrat(14, FontWeight.w300, lineHeightPx: 22);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('ANSWER'),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < card.answer.length; i++) ...[
                if (i > 0) const SizedBox(height: 22),
                Text(card.answer[i], style: body),
              ],
              if (example != null) ...[
                const SizedBox(height: 22),
                Text('Example:', style: body),
                for (final line in example) Text(line, style: body),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 30,
          child: Text(
            'How did you do?',
            textAlign: TextAlign.center,
            style: _montserrat(14, FontWeight.w500),
          ),
        ),
        Row(
          children: [
            _RatingButton(
              label: 'Again',
              interval: '1 min',
              color: LernoColors.coral,
              onTap: () => onRate('again'),
            ),
            const SizedBox(width: 8),
            _RatingButton(
              label: 'Still learning',
              interval: 'Tomorrow',
              color: _amber,
              onTap: () => onRate('learning'),
            ),
            const SizedBox(width: 8),
            _RatingButton(
              label: 'Got it',
              interval: '4 days',
              color: _green,
              onTap: () => onRate('got_it'),
            ),
          ],
        ),
      ],
    );
  }
}

/// White 10% tile (70 tall, radius 20) with a 1px border in [color] at 30%,
/// SemiBold 13 label (y 17) in [color] and Light 11 interval (y 39).
class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.interval,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String interval;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
    );
    return Expanded(
      child: Material(
        color: const Color(0x1AFFFFFF),
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: SizedBox(
            height: 70,
            child: Stack(
              children: [
                Positioned(
                  left: 4,
                  right: 4,
                  top: 17,
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: _montserrat(13, FontWeight.w600, color: color),
                  ),
                ),
                Positioned(
                  left: 4,
                  right: 4,
                  top: 39,
                  child: Text(
                    interval,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: _montserrat(11, FontWeight.w300,
                        color: const Color(0x80FFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
