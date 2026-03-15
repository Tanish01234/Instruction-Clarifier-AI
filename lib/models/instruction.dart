class Instruction {
  final String originalText;
  final DateTime timestamp;
  
  Instruction({
    required this.originalText,
    required this.timestamp,
  });
  
  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      originalText: json['originalText'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
