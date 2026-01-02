import 'dart:convert';

class Steps {
  final String title;
  final List<Step> steps;

  Steps({required this.title, required this.steps});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      title: json['title'] ?? '',
      steps: (json['steps'] as List).map((i) => Step.fromJson(i)).toList(),
    );
  }
}

class Step {
  final int id;
  final String step;

  Step({required this.id, required this.step});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(id: json['id'] as int, step: json['step'] as String);
  }
}
