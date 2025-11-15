enum WeekDays {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday;

  String get displayName {
    switch (this) {
      case WeekDays.sunday:
        return 'Sunday';
      case WeekDays.monday:
        return 'Monday';
      case WeekDays.tuesday:
        return 'Tuesday';
      case WeekDays.wednesday:
        return 'Wednesday';
      case WeekDays.thursday:
        return 'Thursday';
      case WeekDays.friday:
        return 'Friday';
      case WeekDays.saturday:
        return 'Saturday';
    }
  }
}
