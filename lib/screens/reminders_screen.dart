import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';
import '../widgets/gradient_scaffold.dart';

/// Reminders screen with Upcoming / Calendar toggle.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Reminders',
                style: LernoTextStyles.sectionTitle
                    .copyWith(fontFamily: 'MuseoModerno'),
              ),
            ),
            const SizedBox(height: 20),

            // ── Toggle ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: LernoColors.cardDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: LernoColors.divider),
                ),
                child: Row(
                  children: [
                    _toggleButton('Upcoming', !_showCalendar,
                            () => setState(() => _showCalendar = false)),
                    _toggleButton('Calendar', _showCalendar,
                            () => setState(() => _showCalendar = true)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Content ───────────────────────────────────
            Expanded(
              child: _showCalendar
                  ? const _CalendarView()
                  : const _UpcomingView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? LernoColors.coral : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            style: LernoTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: active ? LernoColors.white : LernoColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: LernoColors.scaffoldDark,
        border: Border(
          top: BorderSide(color: LernoColors.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', false),
              _navItem(Icons.menu_book_rounded, 'Lectures', false),
              _navItem(Icons.school_rounded, 'Study', false),
              _navItem(Icons.calendar_today_rounded, 'Reminders', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 24,
              color: active ? LernoColors.coral : LernoColors.textSecondary),
          const SizedBox(height: 4),
          Text(label,
              style: active
                  ? LernoTextStyles.navLabelActive
                  : LernoTextStyles.navLabel),
        ],
      ),
    );
  }
}

// ── Upcoming View ──────────────────────────────────────────────────────

class _UpcomingView extends StatelessWidget {
  const _UpcomingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        // Today
        Text(
          'TODAY — TUESDAY, 8 OCTOBER',
          style: LernoTextStyles.caption.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _ReminderCard(
          title: 'Discrete Mathematics',
          time: '11:00 — 11:50',
          location: 'Queen’s Building · Room 1.15',
          badge: 'in 45 min',
        ),
        const SizedBox(height: 10),
        const _ReminderCard(
          title: 'Introduction to Computer Science',
          time: '14:00 — 15:00',
          location: 'Merchant Venturers · LT1',
        ),
        const SizedBox(height: 28),

        // Tomorrow
        Text(
          'TOMORROW — WEDNESDAY, 9 OCTOBER',
          style: LernoTextStyles.caption.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const _ReminderCard(
          title: 'Discrete Mathematics',
          time: '09:00 — 09:50',
          location: 'Queen’s Building · Room 1.15',
        ),
        const SizedBox(height: 10),
        const _ReminderCard(
          title: 'Programming Workshop',
          time: '13:00 — 15:00',
          location: 'MVB · Computer Lab 2.11',
        ),
      ],
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.title,
    required this.time,
    required this.location,
    this.badge,
  });

  final String title;
  final String time;
  final String location;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LernoColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LernoColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: LernoTextStyles.body
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (badge != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: LernoColors.coral.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: LernoTextStyles.caption.copyWith(
                      color: LernoColors.coral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(time, style: LernoTextStyles.caption),
          const SizedBox(height: 4),
          Text(location, style: LernoTextStyles.caption),
        ],
      ),
    );
  }
}

// ── Calendar View ──────────────────────────────────────────────────────

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  // October 2025 starts on Wednesday (index 2)
  static const int _startWeekday = 2; // 0 = Mon
  static const int _daysInMonth = 31;
  static const int _today = 8;
  static const List<int> _eventDays = [
    8, 9, 10, 13, 14, 15, 16, 17, 20, 21, 22, 23, 27, 28, 29, 30
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.chevron_left,
                  color: LernoColors.white, size: 24),
            ),
            Text(
              'October 2025',
              style: LernoTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.chevron_right,
                  color: LernoColors.white, size: 24),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Day-of-week header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map((d) => SizedBox(
            width: 40,
            child: Center(
              child: Text(d, style: LernoTextStyles.caption),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        _buildGrid(),
        const SizedBox(height: 24),

        // Events for today
        Text(
          'TUESDAY, 8 OCTOBER',
          style: LernoTextStyles.caption.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _calendarEvent(
          title: 'Discrete Mathematics',
          time: '11:00 — 11:50  ·  Queen’s Building · 1.15',
        ),
        const SizedBox(height: 10),
        _calendarEvent(
          title: 'Intro to Computer Science',
          time:
          '14:00 — 15:00  ·  Merchant Venturers · LT1',
        ),
      ],
    );
  }

  Widget _buildGrid() {
    final cells = <Widget>[];
    // Empty leading cells
    for (var i = 0; i < _startWeekday; i++) {
      cells.add(const SizedBox(width: 40, height: 44));
    }
    // Day cells
    for (var day = 1; day <= _daysInMonth; day++) {
      final isToday = day == _today;
      final hasEvent = _eventDays.contains(day);
      final isWeekend = ((day + _startWeekday - 1) % 7) >= 5;

      cells.add(
        SizedBox(
          width: 40,
          height: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: isToday
                    ? const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LernoColors.coral,
                )
                    : null,
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: LernoTextStyles.bodySmall.copyWith(
                    color: isToday
                        ? LernoColors.white
                        : isWeekend
                        ? LernoColors.textSecondary
                        : LernoColors.white,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (hasEvent && !isToday)
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: LernoColors.coral,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.start,
      children: cells,
    );
  }

  Widget _calendarEvent({required String title, required String time}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LernoColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LernoColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              LernoTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(time, style: LernoTextStyles.caption),
        ],
      ),
    );
  }
}