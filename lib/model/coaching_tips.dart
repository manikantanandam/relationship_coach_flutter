import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';
import 'package:relationship_coach_flutter/model/rc_statement.dart';

// 3. Category grouping (e.g., "1. Admit" or "2. Body Feeling")
class CoachingTips extends BaseFirestoreModel {
  @override
  String? id;
  final List<RCStatement> statements;

  CoachingTips({this.id, required this.statements});

  factory CoachingTips.fromJson(dynamic json) {
    return CoachingTips(
      statements: (json as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }

  // Requirement: Convert object to Map for Firestore
  @override
  Map<String, dynamic> toJson() {
    return {
      'statements': statements.map((e) => e.toJson()).toList(),
    };
  }

  // Requirement: Factory for FirestoreService fromJson callback
  factory CoachingTips.fromFirestore(Map<String, dynamic> json, String id) {
    return CoachingTips(
      id: id,
      statements: (json['statements'] as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }
}
