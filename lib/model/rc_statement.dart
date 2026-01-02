import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/enum/gender.dart';
import 'package:relationship_coach_flutter/model/rc_statement_part.dart';

class RCStatement {
  final String speaker;
  final List<RCStatementPart> statementParts;

  RCStatement({required this.speaker, required this.statementParts});

  factory RCStatement.fromJson(Map<String, dynamic> json) {
    return RCStatement(
      speaker: json['speaker'] ?? '',
      statementParts: (json['parts'] as List)
          .map((item) => RCStatementPart.fromJson(item))
          .toList(),
    );
  }

  Widget richText(Gender gender, bool bulletPointNeeded) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bulletPointNeeded
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 8.0,
                ), // Adjust alignment
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: speaker.isEmpty ? '' : '$speaker Said: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                for (var part in statementParts) part.textSpan(gender),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
