import 'package:relationship_coach_flutter/model/rc_statement_part.dart';
import 'package:relationship_coach_flutter/screens/settings_screen.dart';

class PrivacyPolicy {
  final String section;
  final List<RCStatementPart> statements;

  PrivacyPolicy({required this.section, required this.statements});

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      section: json['section'] ?? '',
      statements: (json['statements'] as List)
          .map((item) => RCStatementPart.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'section': section,
      // Map the list of statements into JSON maps
      'statements': statements.map((statement) => statement.toJson()).toList(),
    };
  }

  // Requirement: Factory to create instance from Firestore data
  factory PrivacyPolicy.fromFirestore(Map<String, dynamic> json, String id) {
    return PrivacyPolicy(
      section: json['section'] ?? '',
      statements: (json['statements'] as List? ?? [])
          .map((item) => RCStatementPart.fromJson(item))
          .toList(),
    );
  }
}
