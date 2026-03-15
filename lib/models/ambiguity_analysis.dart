class AmbiguityAnalysis {
  final int score; // 0-100
  final String severity; // Low, Medium, High
  final List<String> vagueWords;
  final String explanation;
  final List<String> missingConstraints;
  
  AmbiguityAnalysis({
    required this.score,
    required this.severity,
    required this.vagueWords,
    required this.explanation,
    required this.missingConstraints,
  });
  
  factory AmbiguityAnalysis.fromJson(Map<String, dynamic> json) {
    return AmbiguityAnalysis(
      score: json['score'] as int,
      severity: json['severity'] as String,
      vagueWords: List<String>.from(json['vagueWords'] as List),
      explanation: json['explanation'] as String,
      missingConstraints: List<String>.from(json['missingConstraints'] as List),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'severity': severity,
      'vagueWords': vagueWords,
      'explanation': explanation,
      'missingConstraints': missingConstraints,
    };
  }
}
