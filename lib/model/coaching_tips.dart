import 'package:relationship_coach_flutter/model/rc_statement.dart';

// 3. Category grouping (e.g., "1. Admit" or "2. Body Feeling")
class CoachingTips {
  final List<RCStatement> statements;

  CoachingTips({required this.statements});

  factory CoachingTips.fromJson(dynamic json) {
    return CoachingTips(
      statements: (json as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }
}
