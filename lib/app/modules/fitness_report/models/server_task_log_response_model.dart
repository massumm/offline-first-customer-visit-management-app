class ServerTaskLagResponseModel {
  ServerTaskLagResponseModel({
    required this.id,
    required this.service,
    required this.task,
    required this.celeryTaskId,
    required this.isRunning,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? service;
  final String? task;
  final String? celeryTaskId;
  final bool? isRunning;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServerTaskLagResponseModel copyWith({
    int? id,
    String? service,
    String? task,
    String? celeryTaskId,
    bool? isRunning,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServerTaskLagResponseModel(
      id: id ?? this.id,
      service: service ?? this.service,
      task: task ?? this.task,
      celeryTaskId: celeryTaskId ?? this.celeryTaskId,
      isRunning: isRunning ?? this.isRunning,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServerTaskLagResponseModel.fromJson(Map<String, dynamic> json){
    return ServerTaskLagResponseModel(
      id: json["id"],
      service: json["service"],
      task: json["task"],
      celeryTaskId: json["celery_task_id"],
      isRunning: json["is_running"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  @override
  String toString(){
    return "$id, $service, $task, $celeryTaskId, $isRunning, $createdAt, $updatedAt, ";
  }
}
