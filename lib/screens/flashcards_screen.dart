import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_bottom_nav.dart';

/// Flashcards — built 1:1 from Figma frame "iPhone 16 & 17 Pro - 23"
/// (node 666:789, 402 × 874). Offsets assume a 62pt status bar.
class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key});

  static const _decks = [
    _Deck('Functions & Parameters', cards: 8, course: 'Intro to CS', due: 3),
    _Deck('Proof by Induction', cards: 15, course: 'Discrete Math', due: 5),
    _Deck('Set Theory Basics', cards: 10, course: 'Discrete Math', due: 2),
    _Deck('Data Types & Variables', cards: 12, course: 'Intro to CS'),
  ];

  void _startSession(BuildContext context) =>
      Navigator.of(context).pushNamed('/study-session');

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
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, top + 18, 20, navSpace + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Figma y 80 → 130.
                SizedBox(
                  height: 50,
                  child: Text(
                    'Flashcards',
                    style: GoogleFonts.museoModerno(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9,
                      color: LernoColors.white,
                    ),
                  ),
                ),
                // y 130 → 155.
                SizedBox(
                  height: 25,
                  child: Text(
                    'DUE TODAY',
                    style: _montserrat(11, FontWeight.w700,
                        color: const Color(0x66FFFFFF), letterSpacing: 1.5),
                  ),
                ),
                _DueTodayCard(
                  course: 'INTRODUCTION TO COMPUTER SCIENCE',
                  title: 'Recursion essentials',
                  details: '12 cards  ·  ~8 min',
                  onStart: () => _startSession(context),
                ),
                // y 315 → 340 → 375.
                const SizedBox(height: 25),
                SizedBox(
                  height: 35,
                  child: Text('Your decks',
                      style: _montserrat(18, FontWeight.w600)),
                ),
                for (var i = 0; i < _decks.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _DeckTile(
                    deck: _decks[i],
                    onTap: () => _startSession(context),
                  ),
                ],
              ],
            ),
          ),
          // Figma shows Home highlighted on this screen too.
          const LernoBottomNav(current: LernoTab.home),
        ],
      ),
    );
  }
}

TextStyle _montserrat(
  double size,
  FontWeight weight, {
  Color color = LernoColors.white,
  double? letterSpacing,
}) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
  );
}

class _Deck {
  const _Deck(this.title,
      {required this.cards, required this.course, this.due = 0});

  final String title;
  final int cards;
  final String course;

  /// Cards due for review today; the pill is hidden when 0.
  final int due;
}

/// White 12% card (362 × 160, radius 20) with the coral session button.
class _DueTodayCard extends StatelessWidget {
  const _DueTodayCard({
    required this.course,
    required this.title,
    required this.details,
    required this.onStart,
  });

  final String course;
  final String title;
  final String details;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: Text(
              course,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(10, FontWeight.w700,
                  color: LernoColors.coral, letterSpacing: 1),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 38,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.museoModerno(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.9,
                color: LernoColors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 68,
            child: Text(
              details,
              style: _montserrat(12, FontWeight.w300,
                  color: const Color(0xB3FFFFFF)),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 104,
            height: 42,
            child: Material(
              color: LernoColors.coral,
              borderRadius: BorderRadius.circular(30),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onStart,
                child: Center(
                  child: Text(
                    'Start study session',
                    style: _montserrat(14, FontWeight.w600,
                        color: LernoColors.plumDeep),
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

/// White 8% row (70 tall, radius 15): title, card count · course, and a
/// coral "n due" pill (50 × 22) on the right when cards are due.
class _DeckTile extends StatelessWidget {
  const _DeckTile({required this.deck, required this.onTap});

  final _Deck deck;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x14FFFFFF),
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 70,
          child: Stack(
            children: [
              Positioned(
                left: 16,
                right: deck.due > 0 ? 78 : 16,
                top: 14,
                child: Text(
                  deck.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(14, FontWeight.w600),
                ),
              ),
              Positioned(
                left: 16,
                right: deck.due > 0 ? 78 : 16,
                top: 40,
                child: Text(
                  '${deck.cards} cards  ·  ${deck.course}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _montserrat(12, FontWeight.w300,
                      color: const Color(0xB3FFFFFF)),
                ),
              ),
              if (deck.due > 0)
                Positioned(
                  right: 16,
                  top: 24,
                  child: Container(
                    width: 50,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x26FD5454),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${deck.due} due',
                      style: _montserrat(10, FontWeight.w600,
                          color: LernoColors.coral),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
