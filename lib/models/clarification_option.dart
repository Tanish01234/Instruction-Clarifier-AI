class ClarificationOption {
  final String id;
  final String title;
  final String description;
  final String value;
  
  ClarificationOption({
    required this.id,
    required this.title,
    required this.description,
    required this.value,
  });
  
  factory ClarificationOption.fromJson(Map<String, dynamic> json) {
    return ClarificationOption(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      value: json['value'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'value': value,
    };
  }
}

class ClarificationQuestion {
  final String aspect; // e.g., "style", "scope", "audience"
  final String question;
  final List<ClarificationOption> options;
  
  ClarificationQuestion({
    required this.aspect,
    required this.question,
    required this.options,
  });
  
  factory ClarificationQuestion.fromJson(Map<String, dynamic> json) {
    return ClarificationQuestion(
      aspect: json['aspect'] as String,
      question: json['question'] as String,
      options: (json['options'] as List)
          .map((e) => ClarificationOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'aspect': aspect,
      'question': question,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
