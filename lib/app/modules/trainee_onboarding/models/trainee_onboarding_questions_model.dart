enum QAType {
  text,
  number,
  multipleChoice,
  date,
  time,
  boolean,
  height,
  weight,
  image,
  phoneNumber,
  unknown,
}

class TraineeOnboardingQuestionDataModel {
  final List<TraineeQuestionData> questionsData;

  TraineeOnboardingQuestionDataModel({required this.questionsData});

  factory TraineeOnboardingQuestionDataModel.fromJson(dynamic json) {
    if (json is List) {
      final questionsData = json
          .map((e) => TraineeQuestionData.fromJson(e as Map<String, dynamic>))
          .toList();
      return TraineeOnboardingQuestionDataModel(questionsData: questionsData);
    }

    // handle unexpected format (Map with 'data' keys)
    if (json is Map && json["data"] != null) {
      final questionsData = (json["results"] as List)
          .map((e) => TraineeQuestionData.fromJson(e))
          .toList();
      return TraineeOnboardingQuestionDataModel(questionsData: questionsData);
    }

    throw Exception(
      "Invalid JSON format for TraineeOnboardingQuestionDataModel",
    );
  }
}

class TraineeQuestionData {
  TraineeQuestionData({
    required this.id,
    required this.traineeOnboarding,
    required this.questionType,
    required this.questionText,
    required this.questionMetadata,
    required this.questionFieldName,
    required this.possibleAnswersMetadata,
    required this.index,
    required this.isOptional,
    required this.groupName,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? traineeOnboarding;
  final QAType? questionType;
  final String? questionText;
  final QuestionMetadata? questionMetadata;
  final String? questionFieldName;
  final PossibleAnswersMetadata? possibleAnswersMetadata;
  final int? index;
  final bool isOptional;
  final String groupName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TraineeQuestionData copyWith({
    int? id,
    int? traineeOnboarding,
    QAType? questionType,
    String? questionText,
    QuestionMetadata? questionMetadata,
    String? questionFieldName,
    PossibleAnswersMetadata? possibleAnswersMetadata,
    int? index,
    bool? isOptional,
    String? groupName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TraineeQuestionData(
      id: id ?? this.id,
      traineeOnboarding: traineeOnboarding ?? this.traineeOnboarding,
      questionType: questionType ?? this.questionType,
      questionText: questionText ?? this.questionText,
      questionMetadata: questionMetadata ?? this.questionMetadata,
      questionFieldName: questionFieldName ?? this.questionFieldName,
      possibleAnswersMetadata:
          possibleAnswersMetadata ?? this.possibleAnswersMetadata,
      index: index ?? this.index,
      isOptional: isOptional ?? this.isOptional,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TraineeQuestionData.fromJson(Map<String, dynamic> json) {
    // Map backend question_type string to QAType enum
    QAType parseQAType(String? type) {
      switch (type) {
        case "text":
          return QAType.text;
        case "number":
          return QAType.number;
        case "multiple_choice":
          return QAType.multipleChoice;
        case "date":
          return QAType.date;
        case "time":
          return QAType.time;
        case "boolean":
          return QAType.boolean;
        case "height":
          return QAType.height;
        case "weight":
          return QAType.weight;
        case "image":
          return QAType.image;
        case "phone_number":
          return QAType.phoneNumber;
        default:
          return QAType.unknown;
      }
    }

    return TraineeQuestionData(
      id: json["id"],
      traineeOnboarding: json["trainee_onboarding"],
      questionType: parseQAType(json["question_type"]),
      questionText: json["question_text"],
      isOptional: json["is_optional"],
      groupName: json["group_name"],
      questionMetadata: json["question_metadata"] == null
          ? QuestionMetadata(json: {})
          : QuestionMetadata.fromJson(json["question_metadata"]),
      questionFieldName: json["question_field_name"],
      possibleAnswersMetadata: json["possible_answers_metadata"] == null
          ? PossibleAnswersMetadata(choices: [])
          : PossibleAnswersMetadata.fromJson(json["possible_answers_metadata"]),
      index: json["index"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  @override
  String toString() {
    return "$id, $traineeOnboarding, ${questionType?.name}, $questionText, $questionFieldName, $index";
  }
}

class PossibleAnswersMetadata {
  PossibleAnswersMetadata({required this.choices});

  final List<String> choices;

  PossibleAnswersMetadata copyWith({List<String>? choices}) {
    return PossibleAnswersMetadata(choices: choices ?? this.choices);
  }

  factory PossibleAnswersMetadata.fromJson(Map<String, dynamic> json) {
    return PossibleAnswersMetadata(
      choices: json["choices"] == null
          ? []
          : List<String>.from(json["choices"].map((x) => x.toString())),
    );
  }

// toJson method
  Map<String, dynamic> toJson() {
    return {
      'choices': choices,
    };
  }



  @override
  String toString() => choices.toString();
}

class QuestionMetadata {
  QuestionMetadata({required this.json});

  final Map<String, dynamic> json;

  factory QuestionMetadata.fromJson(Map<String, dynamic> json) {
    return QuestionMetadata(json: json);
  }

  @override
  String toString() => json.toString();
}
