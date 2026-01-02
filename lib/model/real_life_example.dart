import 'package:relationship_coach_flutter/model/rc_statement.dart';

class RealLifeExample {
  final int id;
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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      scenario: json['scenario'] ?? '',
      statements: (json['dialogue'] as List)
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }
}
