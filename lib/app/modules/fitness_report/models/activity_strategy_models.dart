class TrainingPlan {
  final String title;
  final String description;

  TrainingPlan({
    required this.title,
    required this.description,
  });
}

class ActivityObjective {
  final String asset;
  final String title;
  final String description;

  ActivityObjective({
    required this.asset,
    required this.title,
    required this.description,
  });
}

class EnergySystemFocus {
  final String title;
  final double value;

  EnergySystemFocus({
    required this.title,
    required this.value,
  });
}

class PreferredActivity {
  final String asset;
  final String title;

  PreferredActivity({
    required this.asset,
    required this.title,
  });
}
