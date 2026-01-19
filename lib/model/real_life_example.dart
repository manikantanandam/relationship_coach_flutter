import 'package:flutter/foundation.dart';
import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';
import 'package:relationship_coach_flutter/model/rc_statement.dart';

class RealLifeExample extends BaseFirestoreModel {
  @override
  final String id;
  final String title;
  final String scenario;
  final List<RCStatement> statements;

  RealLifeExample({
    required this.id,
    required this.title,
    required this.scenario,
    required this.statements,
  });

  static List<RealLifeExample> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => RealLifeExample.fromJson(item)).toList();
  }

  // Factory to create an instance from JSON map
  factory RealLifeExample.fromJson(Map<String, dynamic> json) {
    return RealLifeExample(
      id: json['id'] ?? '0',
      title: json['title'] ?? '',
      scenario: json['scenario'] ?? '',
      statements: (json['statements'] as List)
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }

  // Requirement: Implement toJson for Firestore write operations
  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'scenario': scenario,
      // Ensure nested objects are also converted to JSON
      'statements': statements.map((e) => e.toJson()).toList(),
    };
  }

  // Requirement: Factory for FirestoreService fromJson callback
  factory RealLifeExample.fromFirestore(Map<String, dynamic> json, String id) {
    debugPrint('decoding json $json');
    return RealLifeExample(
      id: id,
      title: json['title'] ?? '',
      scenario: json['scenario'] ?? '',
      // Map 'statements' from the list in Firestore
      statements: (json['statements'] as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }
}
