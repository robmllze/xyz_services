//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Firebase Services
//
// Copyright Ⓒ Robert Mollentze.
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Timestamp? letTimestamp(dynamic input) {
  if (input == null) return null;
  if (input is Timestamp) return input;
  if (input is String) {
    final a = int.tryParse(input);
    if (a != null) return Timestamp.fromMillisecondsSinceEpoch(a);
  }
  if (input is DateTime) return Timestamp.fromDate(input);
  switch (input.runtimeType) {
    case int:
      return Timestamp.fromMillisecondsSinceEpoch(input);
    case num:
      return Timestamp.fromMillisecondsSinceEpoch(input.round());
  }
  if (input is Duration) return Timestamp.fromMillisecondsSinceEpoch(input.inMilliseconds);

  return null;
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String? timestampKeyConverter(dynamic key) {
  if (key is Timestamp) {
    return key.microsecondsSinceEpoch.toString();
  }
  return null;
}
