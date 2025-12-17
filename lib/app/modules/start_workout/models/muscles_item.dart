class MusclesItem {
  MusclesItem({
    required this.image,
    required this.label,
    required this.isSelected,
  });

  final String image;
  final String label;
  final bool isSelected;


  // Copy with method
  MusclesItem copyWith({
    String? image,
    String? label,
    bool? isSelected,
  }) {
    return MusclesItem(
      image: image ?? this.image,
      label: label ?? this.label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
