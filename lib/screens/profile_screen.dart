import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';
import '../widgets/gradient_scaffold.dart';

/// User profile / settings screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            children: [
              // ── Back button ────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
              ),
              const SizedBox(height: 24),

              // ── Avatar ─────────────────────────────────
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: LernoColors.cream,
                ),
                alignment: Alignment.center,
                child: Text(
                  'MS',
                  style: LernoTextStyles.cardHeading.copyWith(
                    color: LernoColors.plumDeep,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Name & email ───────────────────────────
              Text('Maya Singh', style: LernoTextStyles.screenTitle),
              const SizedBox(height: 4),
              Text('maya.singh@bristol.ac.uk',
                  style: LernoTextStyles.bodySmall),
              const SizedBox(height: 14),

              // ── Tags ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tag('Year 2'),
                  const SizedBox(width: 8),
                  _tag('BSc Computer Science'),
                ],
              ),
              const SizedBox(height: 32),

              // ── Study section ──────────────────────────
              _sectionLabel('STUDY'),
              const SizedBox(height: 8),
              _settingsRow('Institution & Programme'),
              _settingsRow('Courses'),
              _settingsRow('Study preferences'),
              const SizedBox(height: 24),

              // ── Notifications & Privacy ────────────────
              _sectionLabel('NOTIFICATIONS & PRIVACY'),
              const SizedBox(height: 8),
              _settingsRow('Notification settings'),
              _settingsRow('Privacy & data'),
              _settingsRow('Lecture capture'),
              const SizedBox(height: 32),

              // ── Sign out ───────────────────────────────
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Sign out',
                  style: LernoTextStyles.body.copyWith(
                    color: LernoColors.coral,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: LernoColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LernoColors.divider),
      ),
      child: Text(text, style: LernoTextStyles.bodySmall),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: LernoTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsRow(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: LernoColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LernoColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: LernoTextStyles.body),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: LernoColors.textSecondary, size: 22),
        ],
      ),
    );
  }
}