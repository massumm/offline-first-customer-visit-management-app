class EquipmentItem {
  EquipmentItem({
    required this.image,
    required this.label,
    required this.isSelected,
  });

  // Copy With method
  EquipmentItem copyWith({String? image, String? label, bool? isSelected}) {
    return EquipmentItem(
      image: image ?? this.image,
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  final String image;
  final String label;
  final bool isSelected;
}
