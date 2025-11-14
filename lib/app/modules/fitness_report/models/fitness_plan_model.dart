import 'dart:convert';
import 'package:icon/app/modules/fitness_report/models/daily_goal.dart';

class FitnessPlanModel {
  final int id;
  final int trainer;
  final int trainee;
  final String currentFitnessStateAnalysis;
  final String introductorySummary;
  final String closingRemarks;
  final String recommendedMindsetPrinciple;
  final String recommendedMindsetPrincipleJustification;
  final String createdAt;
  final String updatedAt;
  final List<RecoveryStrategyModel> recoveryStrategies;
  final List<NutritionStrategyModel> nutritionStrategies;
  final List<ActivityStrategyModel> activityStrategies;
  final List<DailyGoal> dailyGoals;

  FitnessPlanModel({
    required this.id,
    required this.trainer,
    required this.trainee,
    required this.currentFitnessStateAnalysis,
    required this.introductorySummary,
    required this.closingRemarks,
    required this.recommendedMindsetPrinciple,
    required this.recommendedMindsetPrincipleJustification,
    required this.createdAt,
    required this.updatedAt,
    required this.recoveryStrategies,
    required this.nutritionStrategies,
    required this.activityStrategies,
    required this.dailyGoals,
  });

  factory FitnessPlanModel.fromJson(Map<String, dynamic> json) {
    return FitnessPlanModel(
      id: json['id'],
      trainer: json['trainer'],
      trainee: json['trainee'],
      currentFitnessStateAnalysis: json['current_fitness_state_analysis'] ?? '',
      introductorySummary: json['introductory_summary'] ?? '',
      closingRemarks: json['closing_remarks'] ?? '',
      recommendedMindsetPrinciple: json['recommended_mindset_principle'] ?? '',
      recommendedMindsetPrincipleJustification:
          json['recommended_mindset_principle_justification'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      recoveryStrategies: (json['recovery_strategies'] as List<dynamic>? ?? [])
          .map((e) => RecoveryStrategyModel.fromJson(e))
          .toList(),
      nutritionStrategies:
          (json['nutrition_strategies'] as List<dynamic>? ?? [])
              .map((e) => NutritionStrategyModel.fromJson(e))
              .toList(),
      activityStrategies: (json['activity_strategies'] as List<dynamic>? ?? [])
          .map((e) => ActivityStrategyModel.fromJson(e))
          .toList(),
      dailyGoals: (json['daily_goals'] as List<dynamic>? ?? [])
          .map(
            (e) => DailyGoal(
              title: e['title'] ?? '',
              frequency: (e['frequency'] as List<dynamic>? ?? [])
                  .map((f) => f.toString())
                  .toList(),
              subtitle: e['subtitle'] ?? '',
              description: e['description'] ?? '',
              icon: e['icon'] ?? '',
            ),
          )
          .toList(),
    );
  }
}

class RecoveryStrategyModel {
  final int id;
  final int fitnessPlan;
  final String generalInsights;
  final String generalLifestyleRecommendations;
  final List<RecoveryObjectiveModel> objectives;

  RecoveryStrategyModel({
    required this.id,
    required this.fitnessPlan,
    required this.generalInsights,
    required this.generalLifestyleRecommendations,
    required this.objectives,
  });

  factory RecoveryStrategyModel.fromJson(Map<String, dynamic> json) {
    return RecoveryStrategyModel(
      id: json['id'],
      fitnessPlan: json['fitness_plan'],
      generalInsights: json['general_insights'] ?? '',
      generalLifestyleRecommendations:
          json['general_lifestyle_recommendations'] ?? '',
      objectives: (json['objectives'] as List<dynamic>? ?? [])
          .map((e) => RecoveryObjectiveModel.fromJson(e))
          .toList(),
    );
  }
}

class RecoveryObjectiveModel {
  final int id;
  final String objective;
  final String description;

  RecoveryObjectiveModel({
    required this.id,
    required this.objective,
    required this.description,
  });

  factory RecoveryObjectiveModel.fromJson(Map<String, dynamic> json) {
    return RecoveryObjectiveModel(
      id: json['id'],
      objective: json['objective'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class NutritionStrategyModel {
  final int id;
  final int fitnessPlan;
  final String generalInsights;
  final String generalDietaryRecommendations;
  final List<NutritionObjectiveModel> objectives;

  NutritionStrategyModel({
    required this.id,
    required this.fitnessPlan,
    required this.generalInsights,
    required this.generalDietaryRecommendations,
    required this.objectives,
  });

  factory NutritionStrategyModel.fromJson(Map<String, dynamic> json) {
    return NutritionStrategyModel(
      id: json['id'],
      fitnessPlan: json['fitness_plan'],
      generalInsights: json['general_insights'] ?? '',
      generalDietaryRecommendations:
          json['general_dietary_recommendations'] ?? '',
      objectives: (json['objectives'] as List<dynamic>? ?? [])
          .map((e) => NutritionObjectiveModel.fromJson(e))
          .toList(),
    );
  }
}

class NutritionObjectiveModel {
  final int id;
  final String objective;
  final String description;

  NutritionObjectiveModel({
    required this.id,
    required this.objective,
    required this.description,
  });

  factory NutritionObjectiveModel.fromJson(Map<String, dynamic> json) {
    return NutritionObjectiveModel(
      id: json['id'],
      objective: json['objective'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ActivityStrategyModel {
  final int id;
  final int fitnessPlan;
  final String generalInsights;
  final String generalDietaryRecommendations;
  final double aerobicFocusPercentage;
  final double glycolyticFocusPercentage;
  final double phosphagenFocusPercentage;
  final List<ActivityObjectiveModel> objectives;
  final List<ActivityFocusAreaModel> focusAreas;

  ActivityStrategyModel({
    required this.id,
    required this.fitnessPlan,
    required this.generalInsights,
    required this.generalDietaryRecommendations,
    required this.aerobicFocusPercentage,
    required this.glycolyticFocusPercentage,
    required this.phosphagenFocusPercentage,
    required this.objectives,
    required this.focusAreas,
  });

  factory ActivityStrategyModel.fromJson(Map<String, dynamic> json) {
    return ActivityStrategyModel(
      id: json['id'],
      fitnessPlan: json['fitness_plan'],
      generalInsights: json['general_insights'] ?? '',
      generalDietaryRecommendations:
          json['general_dietary_recommendations'] ?? '',
      aerobicFocusPercentage: (json['aerobic_focus_percentage'] ?? 0)
          .toDouble(),
      glycolyticFocusPercentage: (json['glycolytic_focus_percentage'] ?? 0)
          .toDouble(),
      phosphagenFocusPercentage: (json['phosphagen_focus_percentage'] ?? 0)
          .toDouble(),
      objectives: (json['objectives'] as List<dynamic>? ?? [])
          .map((e) => ActivityObjectiveModel.fromJson(e))
          .toList(),
      focusAreas: (json['focus_areas'] as List<dynamic>? ?? [])
          .map((e) => ActivityFocusAreaModel.fromJson(e))
          .toList(),
    );
  }
}

class ActivityObjectiveModel {
  final int id;
  final String objective;
  final String description;

  ActivityObjectiveModel({
    required this.id,
    required this.objective,
    required this.description,
  });

  factory ActivityObjectiveModel.fromJson(Map<String, dynamic> json) {
    return ActivityObjectiveModel(
      id: json['id'],
      objective: json['objective'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ActivityFocusAreaModel {
  final int id;
  final String focusArea;
  final String description;
  final int priorityScoreOutOf10;

  ActivityFocusAreaModel({
    required this.id,
    required this.focusArea,
    required this.description,
    required this.priorityScoreOutOf10,
  });

  factory ActivityFocusAreaModel.fromJson(Map<String, dynamic> json) {
    return ActivityFocusAreaModel(
      id: json['id'],
      focusArea: json['focus_area'] ?? '',
      description: json['description'] ?? '',
      priorityScoreOutOf10: json['priority_score_out_of_10'] ?? 0,
    );
  }
}
