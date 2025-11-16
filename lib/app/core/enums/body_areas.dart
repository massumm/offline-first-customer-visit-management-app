enum BodyAreas {
  quads,
  glutes,
  calves,
  lowerBack,
  chest,
  back,
  shoulders,
  triceps,
  biceps,
  abs,
  fullBody,
  cardio,
  hamstrings;

  String get displayName {
    switch (this) {
      case BodyAreas.quads:
        return 'Quads';
      case BodyAreas.glutes:
        return 'Glutes';
      case BodyAreas.calves:
        return 'Calves';
      case BodyAreas.hamstrings:
        return 'Hamstrings';
      case BodyAreas.lowerBack:
        return 'Lower Back';
        case BodyAreas.chest:
          return 'Chest';
        case BodyAreas.back:
          return 'Back';
        case BodyAreas.shoulders:
          return 'Shoulders';
        case BodyAreas.triceps:
          return 'Triceps';
        case BodyAreas.biceps:
          return 'Biceps';
        case BodyAreas.abs:
          return 'Abs';
        case BodyAreas.fullBody:
          return 'Full Body';
        case BodyAreas.cardio:
          return 'Cardio';
    }
  }
}
