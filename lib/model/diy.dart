import 'package:relationship_coach_flutter/model/base_fire_store_model.dart';

class DIYFormField {
  final int id;
  final String label;
  final String? prompt; // Nullable because not all fields have a prompt
  final String type;
  final String placeholder;
  String response;

  DIYFormField({
    required this.id,
    required this.label,
    this.prompt,
    required this.type,
    required this.placeholder,
    this.response = '',
  });

  factory DIYFormField.fromJson(Map<String, dynamic> json) {
    return DIYFormField(
      id: json['id'],
      label: json['label'],
      prompt: json['prompt'], // Will be null if key is missing
      type: json['type'],
      placeholder: json['placeholder'],
      response: json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'prompt': prompt,
      'type': type,
      'placeholder': placeholder,
      'response': response,
    };
  }
}

class DoItYourselfModel extends BaseFirestoreModel {
  @override
  String? id;
  final String title;
  final String subtitle;
  final List<DIYFormField> formFields;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoItYourselfModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.formFields,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoItYourselfModel.fromJson(Map<String, dynamic> json) {
    return DoItYourselfModel(
      title: json['title'],
      subtitle: json['subtitle'],
      formFields: (json['form_fields'] as List)
          .map((field) => DIYFormField.fromJson(field))
          .toList(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'form_fields': formFields.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DoItYourselfModel.fromFirestore(
    Map<String, dynamic> json,
    String id,
  ) {
    return DoItYourselfModel(
      id: id,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      formFields: (json['form_fields'] as List? ?? [])
          .map((field) => DIYFormField.fromJson(field))
          .toList(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
    );
  }
}
