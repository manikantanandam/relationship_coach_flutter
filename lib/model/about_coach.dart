import 'package:relationship_coach_flutter/model/rc_statement.dart';

class AboutCoach {
  final List<RCStatement> statements;

  AboutCoach({required this.statements});

  factory AboutCoach.fromJson(dynamic json) {
    return AboutCoach(
      statements: (json['about_coach'] as List? ?? [])
          .map((item) => RCStatement.fromJson(item))
          .toList(),
    );
  }
}
