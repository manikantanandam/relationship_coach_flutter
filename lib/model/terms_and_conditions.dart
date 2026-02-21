class TermAndCondition {
  final String section;
  final List<String> items;

  TermAndCondition({required this.section, required this.items});

  // Factory constructor for creating a new instance from a map (JSON)
  factory TermAndCondition.fromJson(Map<String, dynamic> json) {
    return TermAndCondition(
      section: json['section'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  // Method to convert an instance back to a map (JSON)
  Map<String, dynamic> toJson() {
    return {'section': section, 'items': items};
  }

  static List<TermAndCondition> fromList(List<dynamic> jsonList) {
    return jsonList.map((item) => TermAndCondition.fromJson(item)).toList();
  }
}
