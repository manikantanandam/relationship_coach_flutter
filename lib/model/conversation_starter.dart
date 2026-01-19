import 'package:relationship_coach_flutter/model/rc_statement.dart';
import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';

// 3. Category grouping (e.g., "1. Admit" or "2. Body Feeling")
class ConversationStarter extends BaseFirestoreModel {
  @override
  String? id;
  final int stepId;
  final String title;
  final List<RCStatement> statements;

  ConversationStarter({
    this.id,
    required this.stepId,
    required this.title,
    required this.statements,
  });

  factory ConversationStarter.fromJson(Map<String, dynamic> json) {
    return ConversationStarter(
      stepId: json['step_id'] ?? 0,
      title: json['title'] ?? '',
      statements: (json['starters'] as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'step_id': stepId,
      'title': title,
      'starters': statements.map((s) => s.toJson()).toList(),
    };
  }

  factory ConversationStarter.fromFirestore(
    Map<String, dynamic> json,
    String id,
  ) {
    return ConversationStarter(
      id: id,
      stepId: json['step_id'] ?? 0,
      title: json['title'] ?? '',
      statements: (json['starters'] as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }

  // Helper to parse the top-level list from your JSON file
  static List<ConversationStarter> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => ConversationStarter.fromJson(item)).toList();
  }
}
