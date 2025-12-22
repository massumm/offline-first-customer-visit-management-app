import 'meal_item.dart';

class MealsResponse {
  final String message;
  final int count;
  final List<Meal> results;

  MealsResponse({
    required this.message,
    required this.count,
    required this.results,
  });

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    return MealsResponse(
      message: json['message'],
      count: json['count'],
      results: (json['results'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList(),
    );
  }
}
