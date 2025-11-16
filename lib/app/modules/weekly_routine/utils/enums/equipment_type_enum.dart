enum EquipmentTypeEnum {
  gym,
  home,
  noEquipment;

  String get displayName {
    switch (this) {
      case EquipmentTypeEnum.gym:
        return 'Gym Equipment';
      case EquipmentTypeEnum.home:
        return 'Home Equipment';
      case EquipmentTypeEnum.noEquipment:
        return 'No Equipment';
    }
  }
}