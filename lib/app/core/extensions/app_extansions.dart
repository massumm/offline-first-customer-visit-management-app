import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


extension WidthHeight on num {
  Widget get width => SizedBox(width: toDouble());

  Widget get height => SizedBox(height: toDouble());
}

// extension AppDateTime on DateTime {
//   String get toMMDDYY => DateFormat("MMM d, y").format(this);
//
//   String get toMMDDYYYY => DateFormat("MMM d, yyyy").format(this);
//
//   String get toDDMMYYYY => DateFormat("dd-MM-yyyy").format(this);
//
//   String get toWEEKDAY => DateFormat.EEEE().format(this);
//
//   String get toYYYMMDD => DateFormat("yyyy-MM-dd").format(this);
//
//   String get tohhMMh => DateFormat.jm().format(this);
//
//   String get toMMOnly => DateFormat.E().format(this);
//
//   String get toHourMinute24 => DateFormat('HH:mm').format(this); // e.g., 14:35
//   String get toHOUR24MINUTESECOND => DateFormat.Hms().format(this);
//
//   String toReadableTime() {
//     final DateTime now = DateTime.now();
//     final DateTime today = DateTime(now.year, now.month, now.day);
//     final DateTime yesterday = today.subtract(const Duration(days: 1));
//     final DateTime dateToCheck = DateTime(year, month, day);
//
//     if (dateToCheck == today) {
//       // If today, show hour and minute (11:20)
//       return DateFormat('HH:mm').format(this);
//     } else if (dateToCheck == yesterday) {
//       // If yesterday, show 'yesterday' text
//       return 'yesterday';
//     } else {
//       // If earlier than yesterday, show Month and date (Apr 24)
//       return DateFormat('MMM d').format(this);
//     }
//   }
// }

extension TimestampExtension on String {
  /// Converts timestamp string to DateTime
  DateTime toDateTime() {
    // Ensure it's a valid numeric string
    if (!RegExp(r'^\d{10,17}$').hasMatch(this)) {
      throw FormatException('Invalid numeric timestamp: $this');
    }

    try {
      final timestamp = int.parse(this);

      if (length >= 16) {
        // Likely microseconds (16–17 digits)
        return DateTime.fromMicrosecondsSinceEpoch(timestamp);
      } else if (length >= 13) {
        // Likely milliseconds (13–15 digits)
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (length == 10) {
        // Likely seconds (Unix timestamp)
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      } else {
        throw FormatException('Timestamp length not valid: $this');
      }
    } catch (e) {
      throw FormatException('Error parsing timestamp: $this');
    }
  }

  // String toReadableTime() {
  //   try {
  //     // Parse millisecond timestamp to DateTime
  //     final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(this));
  //     return dateTime.toReadableTime();
  //   } catch (e) {
  //     return 'Invalid timestamp';
  //   }
  // }

  /// Calculate days remaining for 7-day countdown (similar to CountdownFBTimer in reference)
  int getDaysRemaining7() {
    try {
      final initialTime = toDateTime();
      final targetTime = initialTime.add(const Duration(days: 7));
      final currentTime = DateTime.now();
      final timeDifference = targetTime.difference(currentTime);

      // Return remaining days, ensuring it doesn't go below 0
      return timeDifference.inMilliseconds > 0 ? timeDifference.inDays : 0;
    } catch (e) {
      return 0;
    }
  }

  int getHoursRemaining24() {
    try {
      final initialTime = toDateTime();
      final targetTime = initialTime.add(const Duration(hours: 24));
      final currentTime = DateTime.now();
      final timeDifference = targetTime.difference(currentTime);

      // Return remaining hours, ensuring it doesn't go below 0
      return timeDifference.inMilliseconds > 0 ? timeDifference.inHours : 0;
    } catch (e) {
      return 0;
    }
  }

  // String getTimeOnly() {
  //   try {
  //     final dateTime = DateTime.tryParse(formatTimestamp(this));
  //
  //     if (dateTime == null) return 'n/a';
  //
  //     // DateTime.fromMillisecondsSinceEpoch(int.parse(this));
  //     return DateFormat('HH:mm').format(dateTime);
  //   } catch (e) {
  //     return 'Invalid time';
  //   }
  // }
}

// extension FileFormatter on num {
//   String readableFileSize({bool base1024 = true}) {
//     final base = base1024 ? 1024 : 1000;
//     if (this <= 0) return "0";
//     final units = ["B", "kB", "MB", "GB", "TB"];
//     int digitGroups = (log(this) / log(base)).round();
//     return "${NumberFormat("#,##0.#").format(this / pow(base, digitGroups))} ${units[digitGroups]}";
//   }
// }

// Message type limitations.

enum MediaType {
  image,
  document,
  video,
  voiceMessage,
  template,
}

extension MediaPermissionExtension on String {
  // Internal map with lowercase keys
  static final Map<String, Set<MediaType>> _platformPermissions = {
    "whatsapp": {
      MediaType.image,
      MediaType.document,
      MediaType.video,
      MediaType.voiceMessage,
      MediaType.template,
    },
    "facebook": {
      MediaType.image,
      MediaType.document,
      MediaType.video,
      MediaType.voiceMessage,
    },
    "instagram": {
      MediaType.image,
    },
    "webchat": {
      MediaType.image,
    },
    "twilioSms": {

    },
  };

  /// Maps common name variants to lowercase platform keys
  static final Map<String, String> _aliasMap = {
    "whatsapp": "whatsapp",
    "facebook": "facebook",
    "instagram": "instagram",
    "webchat": "webchat",
    "webChat": "webchat",
    "WebChat": "webchat",
    "twilioSms": "twilioSms",
  };

  /// Normalize platform name using alias map
  String get _normalized {
    final input = toLowerCase();
    return _aliasMap.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase() == input,
      orElse: () => MapEntry(input, input),
    )
        .value;
  }

  bool canSend(MediaType type) {
    return _platformPermissions[_normalized]?.contains(type) ?? false;
  }

  List<MediaType> allowedMedia() {
    return _platformPermissions[_normalized]?.toList() ?? [];
  }
}

// Check HTML string.
extension HtmlChecker on String {
  /// Returns true if the string contains any HTML tags
  bool get isHtml {
    final htmlTagPattern = RegExp(r'<[^>]+>');
    return htmlTagPattern.hasMatch(this);
  }

  bool get isLikelyHtml {
    final cleaned = replaceAll(RegExp(r'\s+'), '');
    final htmlLike = RegExp(r'^<[^>]+>.*<\/[^>]+>$');
    return htmlLike.hasMatch(cleaned);
  }
}

// profile avater on name
extension StringInitials on String {
  String get initials {
    // Remove any character that is not a letter or a space, then trim.
    final sanitizedInput = replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim();

    // Check if it's a phone number (10+ digits, allow +, spaces, dashes)
    final digitsOnly = replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length >= 8) {
      return 'T'; // Phone number icon.
    }

    if (sanitizedInput.isEmpty) return '?';

    // Split into words, filtering out any empty strings from multiple spaces.
    final words = sanitizedInput.split(' ').where((word) => word.isNotEmpty);

    // Take the first letter of the first two words, uppercase them, and join.
    final result = words.take(2).map((word) => word[0].toUpperCase()).join();

    return result.isNotEmpty ? result : '?';
  }
}

//.............Copy Sting.....................
extension CopyToClipboardExtension on String {
  /// Copies the string to the system clipboard.
  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: this));
  }
}

//............Log on debug more............

extension DebugLog on String {
  void log({String name = "Debug--------------->>> "}) {
    if (kDebugMode) {
      developer.log(this, name: name);
    }
  }
}


