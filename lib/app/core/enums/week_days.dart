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

  String get shortName {
    switch (this) {
      case WeekDays.sunday:
        return 'Sun';
      case WeekDays.monday:
        return 'Mon';
      case WeekDays.tuesday:
        return 'Tue';
      case WeekDays.wednesday:
        return 'Wed';
      case WeekDays.thursday:
        return 'Thu';
      case WeekDays.friday:
        return 'Fri';
      case WeekDays.saturday:
        return 'Sat';
    }
  }
}
