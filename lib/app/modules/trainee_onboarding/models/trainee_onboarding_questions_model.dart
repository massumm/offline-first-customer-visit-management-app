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
    required this.type,
    required this.text,
    required this.metadata,
    required this.fieldName,
    required this.index,
    required this.isOptional,
    required this.groupName,
    required this.createdAt,
    required this.updatedAt,
    required this.isLastInGroup,
  });

  final int? id;
  final int? traineeOnboarding;
  final QuestionType type;
  final String text;
  final QuestionMetadata metadata;
  final String fieldName;
  final String index;
  final bool isOptional;
  final String groupName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isLastInGroup;

  TraineeQuestionData copyWith({
    int? id,
    int? traineeOnboarding,
    QuestionType? type,
    String? text,
    QuestionMetadata? metadata,
    String? fieldName,
    String? index,
    bool? isOptional,
    String? groupName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLastInGroup,
  }) {
    return TraineeQuestionData(
      id: id ?? this.id,
      traineeOnboarding: traineeOnboarding ?? this.traineeOnboarding,
      type: type ?? this.type,
      text: text ?? this.text,
      metadata: metadata ?? this.metadata,
      fieldName: fieldName ?? this.fieldName,
      index: index ?? this.index,
      isOptional: isOptional ?? this.isOptional,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLastInGroup: isLastInGroup ?? this.isLastInGroup,
    );
  }

  factory TraineeQuestionData.fromJson(Map<String, dynamic> json) {
    return TraineeQuestionData(
      id: json["id"],
      traineeOnboarding: json["trainee_onboarding"] is Map
          ? json["trainee_onboarding"]["id"]
          : json["trainee_onboarding"],
      type: QuestionType.fromJson(json["type"]),
      text: json["text"] ?? '',
      metadata: QuestionMetadata.fromJson(json["metadata"]),
      fieldName: json["field_name"] ?? '',
      index: json["index"] ?? '',
      isOptional: json["is_optional"] ?? false,
      groupName: json["group_name"] ?? '',
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      isLastInGroup: json["is_last_in_group"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'trainee_onboarding': traineeOnboarding,
    'type': type.toJson(),
    'text': text,
    'metadata': metadata,
    'field_name': fieldName,
    'index': index,
    'is_optional': isOptional,
    'group_name': groupName,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $traineeOnboarding, ${type.name}, $text, $fieldName, $index";
  }
}

class QuestionType {
  final int id;
  final String name;
  final String description;
  final Map<String, dynamic> metadataFields;
  final Map<String, dynamic> responseFields;
  final Map<String, dynamic> examples;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionType({
    required this.id,
    required this.name,
    required this.description,
    required this.metadataFields,
    required this.responseFields,
    required this.examples,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionType.fromJson(Map<String, dynamic> json) {
    return QuestionType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      metadataFields: json['metadata_fields'] ?? {},
      responseFields: json['response_fields'] ?? {},
      examples: json['examples'] ?? {},
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'metadata_fields': metadataFields,
    'response_fields': responseFields,
    'examples': examples,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
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
