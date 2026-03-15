class FinalOutput {
  final String original;
  final String clarified;
  final Map<String, String> improvements;
  final StructuredInstruction structured;
  
  FinalOutput({
    required this.original,
    required this.clarified,
    required this.improvements,
    required this.structured,
  });
  
  factory FinalOutput.fromJson(Map<String, dynamic> json) {
    return FinalOutput(
      original: json['original'] as String,
      clarified: json['clarified'] as String,
      improvements: Map<String, String>.from(json['improvements'] as Map),
      structured: StructuredInstruction.fromJson(
        json['structured'] as Map<String, dynamic>,
      ),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'clarified': clarified,
      'improvements': improvements,
      'structured': structured.toJson(),
    };
  }
}

class StructuredInstruction {
  final String goal;
  final String style;
  final List<String> constraints;
  final String expectedOutcome;
  
  StructuredInstruction({
    required this.goal,
    required this.style,
    required this.constraints,
    required this.expectedOutcome,
  });
  
  factory StructuredInstruction.fromJson(Map<String, dynamic> json) {
    return StructuredInstruction(
      goal: json['goal'] as String,
      style: json['style'] as String,
      constraints: List<String>.from(json['constraints'] as List),
      expectedOutcome: json['expectedOutcome'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'style': style,
      'constraints': constraints,
      'expectedOutcome': expectedOutcome,
    };
  }
}
