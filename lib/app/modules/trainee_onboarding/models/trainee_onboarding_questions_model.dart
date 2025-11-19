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

enum QuestionTypeEnum {
  text,
  number,
  date,
  selectMultiple,
  textarea,
  address,
  numericRange,
  selectMultiplePlusOther,
  dateWithDescription,
  bodyMeasurementsInput,
  selectMultiplePlusOtherWithAdd,
  unknown;

  static QuestionTypeEnum fromString(String? name) {
    switch (name) {
      case 'text':
        return text;
      case 'number':
        return number;
      case 'date':
        return date;
      case 'select_multiple':
        return selectMultiple;
      case 'textarea':
        return textarea;
      case 'address':
        return address;
      case 'numeric_range':
        return numericRange;
      case 'select_multiple_plus_other':
        return selectMultiplePlusOther;
      case 'date_with_description':
        return dateWithDescription;
      case 'body_measurements_input':
        return bodyMeasurementsInput;
      case 'select_multiple_plus_other_with_add':
        return selectMultiplePlusOtherWithAdd;
      default:
        return unknown;
    }
  }
}

extension QuestionTypeEnumExtension on QuestionTypeEnum {
  bool get supportsOptions {
    return [
      QuestionTypeEnum.selectMultiple,
      QuestionTypeEnum.selectMultiplePlusOther,
      QuestionTypeEnum.selectMultiplePlusOtherWithAdd,
    ].contains(this);
  }

  bool get supportsUnitOptions {
    return [
      QuestionTypeEnum.number,
      QuestionTypeEnum.numericRange,
    ].contains(this);
  }
}

class QuestionType {
  final int id;
  final QuestionTypeEnum type;
  final String description;
  final Map<String, dynamic> metadataFields;
  final Map<String, dynamic> responseFields;
  final Map<String, dynamic> examples;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionType({
    required this.id,
    required this.type,
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
      type: QuestionTypeEnum.fromString(json['name']),
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

  String get name {
    switch (type) {
      case QuestionTypeEnum.text:
        return 'text';
      case QuestionTypeEnum.number:
        return 'number';
      case QuestionTypeEnum.date:
        return 'date';
      case QuestionTypeEnum.selectMultiple:
        return 'select_multiple';
      case QuestionTypeEnum.textarea:
        return 'textarea';
      case QuestionTypeEnum.address:
        return 'address';
      case QuestionTypeEnum.numericRange:
        return 'numeric_range';
      case QuestionTypeEnum.selectMultiplePlusOther:
        return 'select_multiple_plus_other';
      case QuestionTypeEnum.dateWithDescription:
        return 'date_with_description';
      case QuestionTypeEnum.bodyMeasurementsInput:
        return 'body_measurements_input';
      case QuestionTypeEnum.selectMultiplePlusOtherWithAdd:
        return 'select_multiple_plus_other_with_add';
      case QuestionTypeEnum.unknown:
        return 'unknown';
    }
  }

  bool get supportsOptions => type.supportsOptions;
  bool get supportsUnitOptions => type.supportsUnitOptions;
  QuestionTypeEnum get typeEnum => type;
}

enum MetadataDatatype {
  text,
  number;

  static MetadataDatatype fromString(String? value) {
    switch (value) {
      case 'text':
        return text;
      case 'number':
        return number;
      default:
        return text; // default fallback
    }
  }
}

enum UnitOptions {
  cm,
  inch;

  static UnitOptions? fromString(String? value) {
    switch (value) {
      case 'cm':
        return cm;
      case 'in':
        return inch;
      default:
        return null;
    }
  }

  String toJsonString() {
    switch (this) {
      case UnitOptions.cm:
        return 'cm';
      case UnitOptions.inch:
        return 'in';
    }
  }
}

class QuestionMetadata {
  final List<String>? options;
  final List<UnitOptions>? unitOptions;
  final List<String>? predefinedOptions;
  final MetadataDatatype? datatype;
  final bool? other;
  final num? minValue;
  final num? maxValue;
  final String? labelMin;
  final String? labelMax;
  final String? unit;

  QuestionMetadata({
    this.options,
    this.unitOptions,
    this.predefinedOptions,
    this.datatype,
    this.other,
    this.minValue,
    this.maxValue,
    this.labelMin,
    this.labelMax,
    this.unit,
  });

  factory QuestionMetadata.fromJson(Map<String, dynamic> json) {
    List<UnitOptions>? unitOptions;
    if (json['unit_options'] != null) {
      if (json['unit_options'] is List) {
        unitOptions = (json['unit_options'] as List)
            .map((e) => UnitOptions.fromString(e.toString()) ?? UnitOptions.cm)
            .cast<UnitOptions>()
            .toList();
      }
    }
    
    return QuestionMetadata(
      options: (json['options'] as List?)?.map((e) => e.toString()).toList(),
      unitOptions: unitOptions,
      predefinedOptions: (json['predefined_options'] as List?)?.map((e) => e.toString()).toList(),
      datatype: json['datatype'] != null ? MetadataDatatype.fromString(json['datatype']) : null,
      other: json['other'] as bool?,
      minValue: json['min_value'] as num?,
      maxValue: json['max_value'] as num?,
      labelMin: json['label_min'] as String?,
      labelMax: json['label_max'] as String?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (options != null) 'options': options,
    if (unitOptions != null) 'unit_options': unitOptions?.map((unit) => unit.toJsonString()).toList(),
    if (predefinedOptions != null) 'predefined_options': predefinedOptions,
    if (datatype != null) 'datatype': datatype?.name,
    if (other != null) 'other': other,
    if (minValue != null) 'min_value': minValue,
    if (maxValue != null) 'max_value': maxValue,
    if (labelMin != null) 'label_min': labelMin,
    if (labelMax != null) 'label_max': labelMax,
    if (unit != null) 'unit': unit,
  };

  @override
  String toString() => toJson().toString();
}
