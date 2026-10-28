import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_bottom_nav.dart';
import '../widgets/lerno_icons.dart';
import '../widgets/lerno_search_field.dart';

/// Lecture detail — header, tab bar and Summary tab built 1:1 from Figma
/// frame "iPhone 16 & 17 Pro - 20" (node 648:281, 402 × 874).
class LectureDetailScreen extends StatefulWidget {
  const LectureDetailScreen({super.key});

  @override
  State<LectureDetailScreen> createState() => _LectureDetailScreenState();
}

class _LectureDetailScreenState extends State<LectureDetailScreen>
    with SingleTickerProviderStateMixin {
  static const _tabs = ['Summary', 'Notes', 'Transcript', 'Cards', 'Quiz'];

  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(LernoTab tab) {
    const routes = {
      LernoTab.home: '/home',
      LernoTab.lectures: '/lecture-detail',
      LernoTab.study: '/flashcards',
      LernoTab.reminders: '/reminders',
    };
    Navigator.pushReplacementNamed(context, routes[tab]!);
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final navSpace = LernoBottomNav.reservedHeight(context);

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
              // Figma y 0 → 234 on Summary, 0 → 197 on the other tabs: the
              // recording meta row only exists on Summary, so it fades out and
              // the tab bar rises 37px as you move away from it.
              AnimatedBuilder(
                animation: _tabController.animation!,
                builder: (context, staticHeader) {
                  final collapse =
                      _tabController.animation!.value.clamp(0.0, 1.0);
                  final metaSpace = 37 * (1 - collapse);
                  return SizedBox(
                    height: top + 135 + metaSpace,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        staticHeader!,
                        Positioned(
                          left: 20,
                          right: 20,
                          top: top + 93,
                          child: IgnorePointer(
                            child: Opacity(
                              opacity: 1 - collapse,
                              child: const _MetaRow(
                                duration: '48:12',
                                details: 'Dr. Elena Park  ·  Today, 9:00 AM',
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          top: top + 93 + metaSpace,
                          child: _SegmentedTabs(
                            controller: _tabController,
                            labels: _tabs,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Positioned.fill(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 20,
                        top: top + 16,
                        child: _GlassBackButton(
                          onTap: () => Navigator.maybePop(context),
                        ),
                      ),
                      Positioned(
                        left: 80,
                        right: 20,
                        top: top + 9,
                        child: const _LectureTitle(
                          course: 'INTRODUCTION TO COMPUTER SCIENCE',
                          title: 'Functions, Recursion &\nProblem Solving',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _SummaryTab(bottomPadding: navSpace + 24),
                    _NotesTab(bottomPadding: navSpace + 24),
                    _TranscriptTab(bottomPadding: navSpace + 24),
                    Padding(
                      padding: EdgeInsets.only(bottom: navSpace),
                      child: const _CardsTab(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: navSpace),
                      child: const _QuizTab(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Figma shows Home highlighted on this screen.
          LernoBottomNav(current: LernoTab.home, onTap: _onNavTap),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Typography
// ═══════════════════════════════════════════════════════════════════════

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
              child: const LernoIcon(
                LernoGlyphs.chevronLeft,
                color: LernoColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Coral course label (Figma y 71) + two-line MuseoModerno title (y 90).
class _LectureTitle extends StatelessWidget {
  const _LectureTitle({required this.course, required this.title});

  final String course;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            course,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _montserrat(10, FontWeight.w700,
                color: LernoColors.coral, letterSpacing: 1),
          ),
          Positioned(
            top: 19,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 55,
              child: Text(
                title,
                style: GoogleFonts.museoModerno(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 26 / 20,
                  letterSpacing: -0.9,
                  color: LernoColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Recording-length pill (coral 15%, 80 × 16) + lecturer / time.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.duration, required this.details});

  final String duration;
  final String details;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0x26FD5454),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 8,
                  top: 2,
                  child: LernoIcon(LernoGlyphs.recording,
                      color: LernoColors.coral),
                ),
                Positioned(
                  left: 26,
                  top: 2,
                  child: Text(
                    duration,
                    style: _montserrat(11, FontWeight.w600,
                        color: LernoColors.coral, lineHeightPx: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              details,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(12, FontWeight.w300,
                  color: const Color(0xB3FFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma tab strip: white 12% track (362 × 42, radius 45) with a sliding
/// coral pill (36 tall, radius 40) that follows swipes between tabs.
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.controller, required this.labels});

  final TabController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(45),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segment = constraints.maxWidth / labels.length;
          return AnimatedBuilder(
            animation: controller.animation!,
            builder: (context, _) {
              final position = controller.animation!.value;
              final selected = position.round();
              return Stack(
                children: [
                  Positioned(
                    left: position * segment,
                    top: 0,
                    width: segment,
                    height: 36,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: LernoColors.coral,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < labels.length; i++)
                        Expanded(
                          child: Semantics(
                            button: true,
                            selected: i == selected,
                            child: GestureDetector(
                              onTap: () => controller.animateTo(i),
                              behavior: HitTestBehavior.opaque,
                              child: SizedBox(
                                height: 36,
                                child: Center(
                                  child: Text(
                                    labels[i],
                                    maxLines: 1,
                                    style: _montserrat(
                                      11,
                                      i == selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: i == selected
                                          ? LernoColors.plumDeep
                                          : LernoColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Summary tab (Figma y 248 → 768)
// ═══════════════════════════════════════════════════════════════════════

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.bottomPadding});

  final double bottomPadding;

  static const _overview =
      'This lecture introduced the fundamentals of functions and recursion in programming. Starting with function definitions and parameters, it built towards understanding recursive problem-solving strategies and their applications in computer science.';

  static const _concepts = [
    'Function definitions & parameters',
    'Recursion & base cases',
    'Call stack & memory',
    'Divide and conquer',
    'Tail recursion optimization',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI disclaimer: white 8%, radius 10, 36 tall.
          Container(
            height: 36,
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const LernoIcon(LernoGlyphs.info, color: Color(0x80FFFFFF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI-generated summary — may contain errors',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _montserrat(11, FontWeight.w300,
                        color: const Color(0x80FFFFFF)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 22,
            child: Text('Overview',
                style: _montserrat(18, FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          Text(
            _overview,
            style: _montserrat(14, FontWeight.w300,
                color: const Color(0xB3FFFFFF), lineHeightPx: 21.7),
          ),
          const SizedBox(height: 13.8),

          SizedBox(
            height: 22,
            child: Text('Key concepts',
                style: _montserrat(18, FontWeight.w600)),
          ),
          for (var i = 0; i < _concepts.length; i++) ...[
            const SizedBox(height: 10),
            _ConceptRow(number: i + 1, title: _concepts[i]),
          ],
        ],
      ),
    );
  }
}

/// White 12% row (48 tall, radius 15): coral Kufam number + title.
class _ConceptRow extends StatelessWidget {
  const _ConceptRow({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 15,
            child: Text(
              number.toString().padLeft(2, '0'),
              style: GoogleFonts.kufam(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: LernoColors.coral,
              ),
            ),
          ),
          Positioned(
            left: 50,
            right: 16,
            top: 15,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(14, FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Notes tab (Figma frame 648:463, cards from y 215)
// ═══════════════════════════════════════════════════════════════════════

class _LectureNote {
  const _LectureNote({
    required this.timestamp,
    required this.title,
    required this.body,
    this.quote,
    this.myNote,
  });

  final String timestamp;
  final String title;
  final String body;

  /// Verbatim line from the lecture, shown with a coral bar.
  final String? quote;

  /// The student's own annotation.
  final String? myNote;
}

class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.bottomPadding});

  final double bottomPadding;

  static const _notes = [
    _LectureNote(
      timestamp: '03:24',
      title: 'Function Definitions',
      body:
          'Functions encapsulate reusable logic with defined inputs (parameters) and outputs (return values).',
      quote:
          '"A function is a reusable block of code that performs a specific task."',
      myNote: 'Remember: params vs arguments distinction',
    ),
    _LectureNote(
      timestamp: '12:08',
      title: 'Recursion Basics',
      body:
          'A recursive function calls itself with a smaller input, approaching a base case that stops the recursion.',
      quote:
          '"A function is a reusable block of code that performs a specific task."',
    ),
    _LectureNote(
      timestamp: '28:45',
      title: 'The Call Stack',
      body:
          'Each function call creates a new frame on the call stack, tracking local variables and return addresses.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 18, 20, bottomPadding),
      itemCount: _notes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, i) => _NoteCard(index: i + 1, note: _notes[i]),
    );
  }
}

/// White 8% card (radius 15, 16px side padding) — number + timestamp,
/// title, body, optional quote and optional "MY NOTE" box.
class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.index, required this.note});

  final int index;
  final _LectureNote note;

  @override
  Widget build(BuildContext context) {
    final quote = note.quote;
    final myNote = note.myNote;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number (Kufam, y 14) and timestamp (y 15).
          SizedBox(
            height: 26,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: GoogleFonts.kufam(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: LernoColors.coral,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    note.timestamp,
                    style: _montserrat(11, FontWeight.w500,
                        color: const Color(0x80FFFFFF)),
                  ),
                ),
              ],
            ),
          ),
          // Title (y 40) → body (y 64).
          SizedBox(
            height: 24,
            child: Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(14, FontWeight.w600),
            ),
          ),
          Text(
            note.body,
            style: _montserrat(13, FontWeight.w300,
                color: const Color(0xB3FFFFFF), lineHeightPx: 20),
          ),
          if (quote != null) ...[
            const SizedBox(height: 4),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: const Color(0x80FD5454),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, right: 8),
                      child: Text(
                        quote,
                        style: _montserrat(12, FontWeight.w300,
                            color: const Color(0x80FFFFFF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Figma: 19px to the note box, 16px extra when the card ends here.
            SizedBox(height: myNote != null ? 19 : 16),
          ],
          if (myNote != null) ...[
            if (quote == null) const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
              decoration: BoxDecoration(
                color: const Color(0x1AFD5454),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MY NOTE',
                    style: _montserrat(10, FontWeight.w700,
                        color: LernoColors.coral, letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    myNote,
                    style: _montserrat(12, FontWeight.w500,
                        color: const Color(0xCCFFFFFF)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Transcript tab (Figma frame 650:655 — search at y 212, entries from 272)
// ═══════════════════════════════════════════════════════════════════════

class _TranscriptLine {
  const _TranscriptLine(this.timestamp, this.speaker, this.text);

  final String timestamp;
  final String speaker;
  final String text;
}

class _TranscriptTab extends StatefulWidget {
  const _TranscriptTab({required this.bottomPadding});

  final double bottomPadding;

  @override
  State<_TranscriptTab> createState() => _TranscriptTabState();
}

class _TranscriptTabState extends State<_TranscriptTab> {
  static const _lines = [
    _TranscriptLine('00:15', 'Dr. Elena Park',
        "Good morning everyone. Today we're going to explore one of the most fundamental concepts in programming — functions. How we define them, how we use them, and eventually, how they can call themselves."),
    _TranscriptLine('03:24', 'Dr. Elena Park',
        'A function is essentially a reusable block of code. You define it once, and you can call it as many times as you need. Think of it as giving a name to a set of instructions.'),
    _TranscriptLine('08:42', 'Dr. Elena Park',
        'Now, parameters versus arguments — this trips people up. Parameters are the variables in the function definition. Arguments are the actual values you pass when calling the function.'),
    _TranscriptLine('12:08', 'Dr. Elena Park',
        'Recursion is when a function calls itself. It sounds circular, but the key is that each call works on a smaller piece of the problem, until we reach what we call the base case.'),
    _TranscriptLine('18:30', 'Dr. Elena Park',
        'Let me show you the classic example — calculating a factorial. Five factorial is five times four factorial, which is four times three factorial, and so on down to one.'),
  ];

  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_TranscriptLine> get _visibleLines {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _lines;
    return _lines
        .where((l) =>
            l.text.toLowerCase().contains(q) ||
            l.speaker.toLowerCase().contains(q) ||
            l.timestamp.contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lines = _visibleLines;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20, 15, 20, widget.bottomPadding),
      children: [
        // White 12%, 42 tall; 18px icon at x 16, text at x 42.
        LernoSearchField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          hintText: 'Search transcript',
          height: 42,
          fillColor: const Color(0x1FFFFFFF),
          leftPadding: 16,
          iconSize: 18,
          iconGap: 8,
          iconColor: const Color(0xB3FFFFFF),
          hintColor: const Color(0x80FFFFFF),
        ),
        const SizedBox(height: 18),
        if (lines.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              'No part of the transcript mentions “${_query.trim()}”.',
              textAlign: TextAlign.center,
              style: _montserrat(13, FontWeight.w300,
                  color: const Color(0x80FFFFFF), lineHeightPx: 20),
            ),
          ),
        for (var i = 0; i < lines.length; i++)
          _TranscriptEntry(line: lines[i], isLast: i == lines.length - 1),
      ],
    );
  }
}

/// Timestamp (coral) + speaker, 13px transcript text, then an 8% white
/// hairline 18px below the text and 9px above the next entry.
class _TranscriptEntry extends StatelessWidget {
  const _TranscriptEntry({required this.line, required this.isLast});

  final _TranscriptLine line;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 22,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  line.timestamp,
                  style: _montserrat(12, FontWeight.w600,
                      color: LernoColors.coral),
                ),
              ),
              Expanded(
                child: Text(
                  line.speaker,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(12, FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Text(
          line.text,
          style: _montserrat(13, FontWeight.w300,
              color: const Color(0xB3FFFFFF), lineHeightPx: 20),
        ),
        if (!isLast) ...[
          const SizedBox(height: 18),
          const SizedBox(
            height: 1,
            width: double.infinity,
            child: ColoredBox(color: Color(0x14FFFFFF)),
          ),
          const SizedBox(height: 9),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Remaining tabs — unchanged until their Figma frames are implemented.
// ═══════════════════════════════════════════════════════════════════════

// ── Cards Tab (placeholder) ────────────────────────────────────────────

class _CardsTab extends StatelessWidget {
  const _CardsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Flashcards will appear here',
        style: LernoTextStyles.bodySmall,
      ),
    );
  }
}

// ── Quiz Tab (placeholder) ─────────────────────────────────────────────

class _QuizTab extends StatelessWidget {
  const _QuizTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Quiz will appear here',
        style: LernoTextStyles.bodySmall,
      ),
    );
  }
}
