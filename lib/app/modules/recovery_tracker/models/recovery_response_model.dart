import 'dart:convert';

import 'package:icon/app/modules/recovery_tracker/models/recovery_entry_model.dart';

// Helper function to decode a list of recovery entries
RecoveryEntriesResponse recoveryEntriesResponseFromJson(String str) => RecoveryEntriesResponse.fromJson(json.decode(str));

// Helper function to encode a list of recovery entries
String recoveryEntriesResponseToJson(RecoveryEntriesResponse data) => json.encode(data.toJson());

class RecoveryEntriesResponse {
  String? message; // Added 'message' field
  int? count;      // Added 'count' field
  List<RecoveryEntry>? results;

  RecoveryEntriesResponse({
    this.message,
    this.count,
    this.results,
  });

  factory RecoveryEntriesResponse.fromJson(Map<String, dynamic> json) => RecoveryEntriesResponse(
    message: json["message"],
    count: json["count"],
    results: json["results"] == null ? [] : List<RecoveryEntry>.from(json["results"]!.map((x) => RecoveryEntry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}
