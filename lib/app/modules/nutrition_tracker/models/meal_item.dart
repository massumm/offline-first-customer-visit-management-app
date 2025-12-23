class Meal {
  final int id;
  final int user;
  final String name;
  final int calorieCount;
  final int proteinGrams;
  final int fatGrams;
  final int carbohydrateGrams;
  final String? mealImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    required this.id,
    required this.user,
    required this.name,
    required this.calorieCount,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbohydrateGrams,
    this.mealImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      user: json['user'],
      name: json['name'],
      calorieCount: json['calorie_count'],
      proteinGrams: json['protein_grams'],
      fatGrams: json['fat_grams'],
      carbohydrateGrams: json['carbohydrate_grams'],
      mealImage: json['meal_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'name': name,
      'calorie_count': calorieCount,
      'protein_grams': proteinGrams,
      'fat_grams': fatGrams,
      'carbohydrate_grams': carbohydrateGrams,
      'meal_image': mealImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
