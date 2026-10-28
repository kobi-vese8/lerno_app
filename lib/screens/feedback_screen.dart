import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';
import '../widgets/gradient_scaffold.dart';

/// Confidential Feedback screen.
///
/// Allows students to anonymously rate lectures on
/// Content, Pace, Clarity, Engagement, and Materials.
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String _selectedCategory = 'Pace';
  String? _selectedRating;

  static const _categories = [
    'Content',
    'Pace',
    'Clarity',
    'Engagement',
    'Materials',
  ];

  // Ratings change per category; these are for "Pace"
  static const _paceRatings = ['Too slow', 'Just right', 'Too fast'];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: LernoColors.teal.withValues(alpha: 0.2),
                      ),
                      child: const Icon(Icons.chevron_left_rounded,
                          color: LernoColors.teal, size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Confidential Feedback',
                      style: LernoTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Scrollable content ────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Anonymous notice
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: LernoColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: LernoColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline,
                              size: 16, color: LernoColors.textSecondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your feedback is completely anonymous.\nLecturers cannot identify you.',
                              style: LernoTextStyles.caption.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Select lecture
                    Text('Select lecture', style: LernoTextStyles.body),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: LernoColors.inputFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: LernoColors.divider),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Functions, Recursion & Problem Solving',
                              style: LernoTextStyles.body,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: LernoColors.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category chips
                    Text('Category', style: LernoTextStyles.body),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = cat == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedCategory = cat),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? LernoColors.coral
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? LernoColors.coral
                                        : LernoColors.divider,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: LernoTextStyles.bodySmall.copyWith(
                                    color: isSelected
                                        ? LernoColors.white
                                        : LernoColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rating question
                    Text('How was the pace?', style: LernoTextStyles.body),
                    const SizedBox(height: 12),
                    Row(
                      children: _paceRatings.map((rating) {
                        final isSelected = rating == _selectedRating;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedRating = rating),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? LernoColors.coral
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? LernoColors.coral
                                      : LernoColors.divider,
                                ),
                              ),
                              child: Text(
                                rating,
                                style: LernoTextStyles.bodySmall.copyWith(
                                  color: isSelected
                                      ? LernoColors.white
                                      : LernoColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Additional comments
                    Text('Additional comments', style: LernoTextStyles.body),
                    const SizedBox(height: 10),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: LernoColors.inputFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: LernoColors.divider),
                      ),
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        style: LernoTextStyles.body,
                        decoration: InputDecoration(
                          hintText:
                          'Share your thoughts on how the lecture could be improved...',
                          hintStyle: LernoTextStyles.bodySmall,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Submit button ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LernoColors.coralGradient,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Submit feedback
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Review feedback',
                      style: LernoTextStyles.button
                          .copyWith(color: LernoColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}