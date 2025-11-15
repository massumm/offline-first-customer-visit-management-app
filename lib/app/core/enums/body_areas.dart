enum BodyAreas {
  quads,
  glutes,
  calves,
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
    }
  }
}
