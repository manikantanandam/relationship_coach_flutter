class DIYFormField {
  final int id;
  final String label;
  final String? prompt; // Nullable because not all fields have a prompt
  final String type;
  final String placeholder;

  DIYFormField({
    required this.id,
    required this.label,
    this.prompt,
    required this.type,
    required this.placeholder,
  });

  factory DIYFormField.fromJson(Map<String, dynamic> json) {
    return DIYFormField(
      id: json['id'],
      label: json['label'],
      prompt: json['prompt'], // Will be null if key is missing
      type: json['type'],
      placeholder: json['placeholder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'prompt': prompt,
      'type': type,
      'placeholder': placeholder,
    };
  }
}

class DoItYourselfModel {
  final String title;
  final String subtitle;
  final List<DIYFormField> formFields;

  DoItYourselfModel({
    required this.title,
    required this.subtitle,
    required this.formFields,
  });

  factory DoItYourselfModel.fromJson(Map<String, dynamic> json) {
    return DoItYourselfModel(
      title: json['title'],
      subtitle: json['subtitle'],
      formFields: (json['form_fields'] as List)
          .map((field) => DIYFormField.fromJson(field))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'form_fields': formFields.map((e) => e.toJson()).toList(),
    };
  }
}
