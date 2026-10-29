import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/lerno_theme.dart';
import '../widgets/coral_glow.dart';
import '../widgets/lerno_bottom_nav.dart';
import '../widgets/lerno_icons.dart';

/// Reminders — built 1:1 from Figma frames "iPhone 16 & 17 Pro - 26"
/// (Upcoming, node 675:315) and "- 27" (Calendar, node 675:379).
/// Offsets assume a 62pt status bar.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _showCalendar = false;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Figma: title y 80, toggle y 120 → 162.
              Padding(
                padding: EdgeInsets.fromLTRB(20, top + 18, 20, 0),
                child: SizedBox(
                  height: 40,
                  child: Text(
                    'Reminders',
                    style: GoogleFonts.museoModerno(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9,
                      color: LernoColors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SegmentToggle(
                  labels: const ['Upcoming', 'Calendar'],
                  selected: _showCalendar ? 1 : 0,
                  onChanged: (i) => setState(() => _showCalendar = i == 1),
                ),
              ),
              Expanded(
                child: _showCalendar
                    ? _CalendarView(bottomPadding: navSpace + 24)
                    : _UpcomingView(bottomPadding: navSpace + 24),
              ),
            ],
          ),
          // Not shown in this Figma frame; kept so the tab stays reachable.
          const LernoBottomNav(current: LernoTab.reminders),
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

/// Figma toggle: white 12% track (42 tall, radius 45) with a sliding coral
/// pill (36 tall, radius 40). Labels Montserrat 13 — SemiBold plum when
/// active, Medium white otherwise.
class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment(
                labels.length == 1 ? 0 : -1 + 2 * selected / (labels.length - 1),
                0),
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LernoColors.coral,
                  borderRadius: BorderRadius.circular(40),
                ),
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
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(i),
                      child: Center(
                        child: Text(
                          labels[i],
                          style: _montserrat(
                            13,
                            i == selected ? FontWeight.w600 : FontWeight.w500,
                            color: i == selected
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
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Upcoming (Figma: first day header at y 185)
// ═══════════════════════════════════════════════════════════════════════

class _Reminder {
  const _Reminder(this.title, this.time, this.location, {this.countdown});

  final String title;
  final String time;
  final String location;

  /// Coral "in 45 min" pill for the next lecture, if any.
  final String? countdown;
}

class _ReminderDay {
  const _ReminderDay(this.label, this.reminders);

  final String label;
  final List<_Reminder> reminders;
}

class _UpcomingView extends StatelessWidget {
  const _UpcomingView({required this.bottomPadding});

  final double bottomPadding;

  static const _days = [
    _ReminderDay('TODAY — TUESDAY, 8 OCTOBER', [
      _Reminder('Discrete Mathematics', '11:00 — 11:50',
          "Queen's Building · Room 1.15",
          countdown: 'in 45 min'),
      _Reminder('Introduction to Computer Science', '14:00 — 15:00',
          'Merchant Venturers · LT1'),
    ]),
    _ReminderDay('TOMORROW — WEDNESDAY, 9 OCTOBER', [
      _Reminder('Discrete Mathematics', '09:00 — 09:50',
          "Queen's Building · Room 1.15"),
      _Reminder('Programming Workshop', '13:00 — 15:00',
          'MVB · Computer Lab 2.11'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 23, 20, bottomPadding),
      children: [
        for (var d = 0; d < _days.length; d++) ...[
          // 30px between a day's last card and the next header.
          if (d > 0) const SizedBox(height: 30),
          SizedBox(
            height: 25,
            child: Text(
              _days[d].label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(11, FontWeight.w700,
                  color: const Color(0x66FFFFFF), letterSpacing: 1.5),
            ),
          ),
          for (var i = 0; i < _days[d].reminders.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _ReminderCard(reminder: _days[d].reminders[i]),
          ],
        ],
      ],
    );
  }
}

/// White 8% card (80 tall, radius 15, 1px coral-15% border): title (y 13),
/// time (y 37), location (y 55) and an optional countdown pill.
class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.reminder});

  final _Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final countdown = reminder.countdown;
    final detail = _montserrat(12, FontWeight.w300,
        color: const Color(0xB3FFFFFF));

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0x26FD5454)),
      ),
      child: Stack(
        children: [
          // Figma offsets include the 1px border.
          Positioned(
            left: 14,
            right: countdown != null ? 90 : 14,
            top: 12,
            child: Text(
              reminder.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(14, FontWeight.w600),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 36,
            child: Text(reminder.time, maxLines: 1, style: detail),
          ),
          Positioned(
            left: 14,
            right: 14,
            top: 54,
            child: Text(
              reminder.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: detail,
            ),
          ),
          if (countdown != null)
            Positioned(
              right: 16,
              top: 12,
              child: Container(
                height: 24,
                constraints: const BoxConstraints(minWidth: 70),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x26FD5454),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  countdown,
                  style: _montserrat(11, FontWeight.w600,
                      color: LernoColors.coral),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Calendar (Figma frame 675:379 — month row at y 185, grid from y 230)
// ═══════════════════════════════════════════════════════════════════════

class _CalendarEvent {
  const _CalendarEvent(this.title, this.details);

  final String title;
  final String details;
}

class _CalendarView extends StatefulWidget {
  const _CalendarView({required this.bottomPadding});

  final double bottomPadding;

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  // Sample data matching the design: "today" is 8 October 2025.
  static final _today = DateTime(2025, 10, 8);
  static final _eventDates = {
    for (final d in [7, 9, 13, 14, 15, 16, 20, 21, 22, 23, 27, 28, 29, 30, 8])
      DateTime(2025, 10, d),
  };

  // Weekly timetable used for days that have lectures.
  static const _schedule = {
    DateTime.monday: [
      _CalendarEvent('Discrete Mathematics',
          "11:00 — 11:50  ·  Queen's Building · 1.15"),
    ],
    DateTime.tuesday: [
      _CalendarEvent('Intro to Computer Science',
          '14:00 — 15:00  ·  Merchant Venturers · LT1'),
    ],
    DateTime.wednesday: [
      _CalendarEvent('Discrete Mathematics',
          "11:00 — 11:50  ·  Queen's Building · 1.15"),
      _CalendarEvent('Intro to Computer Science',
          '14:00 — 15:00  ·  Merchant Venturers · LT1'),
    ],
    DateTime.thursday: [
      _CalendarEvent('Discrete Mathematics',
          "09:00 — 09:50  ·  Queen's Building · 1.15"),
      _CalendarEvent('Programming Workshop',
          '13:00 — 15:00  ·  MVB · Computer Lab 2.11'),
    ],
  };

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY',
    'SUNDAY',
  ];

  late DateTime _month = DateTime(_today.year, _today.month);
  late DateTime _selected = _today;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<_CalendarEvent> _eventsOn(DateTime day) =>
      _eventDates.any((d) => _sameDay(d, day))
          ? _schedule[day.weekday] ?? const []
          : const [];

  void _shiftMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final events = _eventsOn(_selected);

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 23, 20, widget.bottomPadding),
      children: [
        // Month row: 30 tall, chevrons 20px at y 5, SemiBold 16 title.
        SizedBox(
          height: 30,
          child: Row(
            children: [
              _MonthChevron(
                label: 'Previous month',
                onTap: () => _shiftMonth(-1),
              ),
              Expanded(
                child: Text(
                  '${_months[_month.month - 1]} ${_month.year}',
                  textAlign: TextAlign.center,
                  style: _montserrat(16, FontWeight.w600),
                ),
              ),
              _MonthChevron(
                label: 'Next month',
                flip: true,
                onTap: () => _shiftMonth(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Weekday initials (y 230) in 50px columns.
        SizedBox(
          height: 26,
          child: Row(
            children: [
              for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                SizedBox(
                  width: _DayCell.width,
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: _montserrat(12, FontWeight.w500,
                        color: const Color(0x66FFFFFF)),
                  ),
                ),
            ],
          ),
        ),
        ..._buildWeeks(),
        // y 476 → day header at 500 → cards at 525.
        const SizedBox(height: 24),
        SizedBox(
          height: 25,
          child: Text(
            '${_weekdays[_selected.weekday - 1]}, ${_selected.day} '
            '${_months[_selected.month - 1].toUpperCase()}',
            style: _montserrat(11, FontWeight.w700,
                color: const Color(0x66FFFFFF), letterSpacing: 1.5),
          ),
        ),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'No lectures on this day.',
              style: _montserrat(12, FontWeight.w300,
                  color: const Color(0x80FFFFFF)),
            ),
          ),
        for (var i = 0; i < events.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _CalendarEventCard(event: events[i]),
        ],
      ],
    );
  }

  List<Widget> _buildWeeks() {
    final first = DateTime(_month.year, _month.month);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = first.weekday - 1; // Monday-first grid.
    final weeks = <Widget>[];
    for (var start = 1 - leading; start <= daysInMonth; start += 7) {
      weeks.add(Row(
        children: [
          for (var i = 0; i < 7; i++)
            if (start + i < 1 || start + i > daysInMonth)
              const SizedBox(width: _DayCell.width, height: _DayCell.height)
            else
              _buildCell(DateTime(_month.year, _month.month, start + i), i),
        ],
      ));
    }
    return weeks;
  }

  Widget _buildCell(DateTime day, int column) {
    return _DayCell(
      day: day.day,
      selected: _sameDay(day, _selected),
      today: _sameDay(day, _today),
      weekend: column >= 5,
      hasEvents: _eventDates.any((d) => _sameDay(d, day)),
      onTap: () => setState(() => _selected = day),
    );
  }
}

class _MonthChevron extends StatelessWidget {
  const _MonthChevron({
    required this.label,
    required this.onTap,
    this.flip = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    final icon = LernoIcon(LernoGlyphs.chevronLeft,
        color: LernoColors.white, semanticLabel: label);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 30,
        height: 30,
        child: Align(
          alignment: flip ? Alignment.centerRight : Alignment.centerLeft,
          child: flip ? Transform.flip(flipX: true, child: icon) : icon,
        ),
      ),
    );
  }
}

/// 50 × 44 grid cell: Medium 14 number 8px from the top, a 38px coral
/// circle behind the selected day, and a 4px coral dot (y 30) for days
/// with lectures. Weekends are white 40%.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.today,
    required this.weekend,
    required this.hasEvents,
    required this.onTap,
  });

  static const width = 50.0;
  static const height = 44.0;

  final int day;
  final bool selected;
  final bool today;
  final bool weekend;
  final bool hasEvents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (selected) {
      color = LernoColors.plumDeep;
    } else if (today) {
      color = LernoColors.coral;
    } else {
      color = weekend ? const Color(0x66FFFFFF) : LernoColors.white;
    }

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (selected)
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: LernoColors.coral,
                    shape: BoxShape.circle,
                  ),
                ),
              Positioned(
                top: 8,
                child: Text(
                  '$day',
                  style: _montserrat(
                    14,
                    selected || today ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
              if (hasEvents && !selected)
                Positioned(
                  top: 30,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: LernoColors.coral,
                      shape: BoxShape.circle,
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

/// White 8% card (56 tall, radius 12): SemiBold 13 title (y 10) and a
/// Light 11 time · place line (y 32).
class _CalendarEventCard extends StatelessWidget {
  const _CalendarEventCard({required this.event});

  final _CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            right: 12,
            top: 10,
            child: Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(13, FontWeight.w600),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 32,
            child: Text(
              event.details,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(11, FontWeight.w300,
                  color: const Color(0xB3FFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}
