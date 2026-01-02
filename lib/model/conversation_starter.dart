import 'package:relationship_coach_flutter/model/rc_statement.dart';

// 3. Category grouping (e.g., "1. Admit" or "2. Body Feeling")
class ConversationStarter {
  final int stepId;
  final String title;
  final List<RCStatement> statements;

  ConversationStarter({
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

  // Helper to parse the top-level list from your JSON file
  static List<ConversationStarter> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => ConversationStarter.fromJson(item)).toList();
  }
}
