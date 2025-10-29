class TraineeOnboardingQuestionsModel {
  TraineeOnboardingQuestionsModel({
    required this.id,
    required this.traineeOnboarding,
    required this.questionType,
    required this.questionText,
    required this.questionMetadata,
    required this.questionFieldName,
    required this.possibleAnswersMetadata,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? traineeOnboarding;
  final String? questionType;
  final String? questionText;
  final QuestionMetadata? questionMetadata;
  final String? questionFieldName;
  final PossibleAnswersMetadata? possibleAnswersMetadata;
  final int? index;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TraineeOnboardingQuestionsModel copyWith({
    int? id,
    int? traineeOnboarding,
    String? questionType,
    String? questionText,
    QuestionMetadata? questionMetadata,
    String? questionFieldName,
    PossibleAnswersMetadata? possibleAnswersMetadata,
    int? index,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TraineeOnboardingQuestionsModel(
      id: id ?? this.id,
      traineeOnboarding: traineeOnboarding ?? this.traineeOnboarding,
      questionType: questionType ?? this.questionType,
      questionText: questionText ?? this.questionText,
      questionMetadata: questionMetadata ?? this.questionMetadata,
      questionFieldName: questionFieldName ?? this.questionFieldName,
      possibleAnswersMetadata: possibleAnswersMetadata ?? this.possibleAnswersMetadata,
      index: index ?? this.index,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TraineeOnboardingQuestionsModel.fromJson(Map<String, dynamic> json){
    return TraineeOnboardingQuestionsModel(
      id: json["id"],
      traineeOnboarding: json["trainee_onboarding"],
      questionType: json["question_type"],
      questionText: json["question_text"],
      questionMetadata: json["question_metadata"] == null ? null : QuestionMetadata.fromJson(json["question_metadata"]),
      questionFieldName: json["question_field_name"],
      possibleAnswersMetadata: json["possible_answers_metadata"] == null ? null : PossibleAnswersMetadata.fromJson(json["possible_answers_metadata"]),
      index: json["index"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  @override
  String toString(){
    return "$id, $traineeOnboarding, $questionType, $questionText, $questionMetadata, $questionFieldName, $possibleAnswersMetadata, $index, $createdAt, $updatedAt, ";
  }
}

class PossibleAnswersMetadata {
  PossibleAnswersMetadata({
    required this.choices,
  });

  final List<String> choices;

  PossibleAnswersMetadata copyWith({
    List<String>? choices,
  }) {
    return PossibleAnswersMetadata(
      choices: choices ?? this.choices,
    );
  }

  factory PossibleAnswersMetadata.fromJson(Map<String, dynamic> json){
    return PossibleAnswersMetadata(
      choices: json["choices"] == null ? [] : List<String>.from(json["choices"]!.map((x) => x)),
    );
  }

  @override
  String toString(){
    return "$choices, ";
  }
}

class QuestionMetadata {
  QuestionMetadata({required this.json});
  final Map<String,dynamic> json;

  factory QuestionMetadata.fromJson(Map<String, dynamic> json){
    return QuestionMetadata(
        json: json
    );
  }

  @override
  String toString(){
    return "";
  }
}
