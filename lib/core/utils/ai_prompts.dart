class AiPrompts {
  // Prompt 1: Ambiguity Analysis
  static String getAnalysisPrompt(String userInput) {
    return '''
Analyze this instruction and identify ambiguities:

INSTRUCTION: "$userInput"

Your task:
1. Detect vague/ambiguous words (e.g., "better", "professional", "simple", "modern", "smart", "impactful", "clean", "nice")
2. Calculate ambiguity severity (Low: 0-33, Medium: 34-66, High: 67-100)
3. Identify missing context in categories: style, scope, audience, constraints, technical requirements

Respond ONLY in this JSON format (no markdown, no extra text):
{
  "score": <number 0-100>,
  "severity": "<Low|Medium|High>",
  "vagueWords": ["word1", "word2"],
  "explanation": "<One sentence explaining why this is ambiguous>",
  "missingConstraints": ["constraint1", "constraint2"]
}

Example response:
{
  "score": 75,
  "severity": "High",
  "vagueWords": ["professional", "modern"],
  "explanation": "This instruction can mean 3 different things depending on whether 'professional' refers to corporate, startup, or creative contexts.",
  "missingConstraints": ["target audience", "visual style", "scope of work"]
}
''';
  }
  
  // Prompt 2: Clarification Options Generation
  static String getClarificationPrompt(
    String instruction,
    String ambiguousAspect,
    List<String> vagueWords,
  ) {
    return '''
Generate clarification options for this instruction:

INSTRUCTION: "$instruction"
AMBIGUOUS ASPECT: "$ambiguousAspect"
VAGUE WORDS: ${vagueWords.join(", ")}

Your task:
Generate 3 meaningfully different MCQ options to clarify the most critical ambiguity.

Rules:
- Each option should represent a DISTINCT interpretation
- Use simple, jargon-free language
- Make options actionable
- Focus on the most important ambiguity first

Respond ONLY in this JSON format (no markdown, no extra text):
{
  "aspect": "<style|scope|audience|constraints>",
  "question": "What do you mean by '<vague_word>'?",
  "options": [
    {
      "id": "1",
      "title": "<Short title>",
      "description": "<One-line description>",
      "value": "<specific interpretation>"
    },
    {
      "id": "2",
      "title": "<Short title>",
      "description": "<One-line description>",
      "value": "<specific interpretation>"
    },
    {
      "id": "3",
      "title": "<Short title>",
      "description": "<One-line description>",
      "value": "<specific interpretation>"
    }
  ]
}

Example response:
{
  "aspect": "style",
  "question": "What do you mean by 'professional'?",
  "options": [
    {
      "id": "1",
      "title": "Corporate & Formal",
      "description": "Suits, ties, conservative colors",
      "value": "corporate-formal"
    },
    {
      "id": "2",
      "title": "Modern Startup-style",
      "description": "Bold, clean, innovative vibe",
      "value": "modern-startup"
    },
    {
      "id": "3",
      "title": "Creative & Visual-heavy",
      "description": "Artistic, unique, expressive",
      "value": "creative-visual"
    }
  ]
}
''';
  }
  
  // Prompt 3: Final Instruction Generation
  static String getFinalInstructionPrompt(
    String originalInstruction,
    Map<String, String> clarifications,
  ) {
    final clarificationsText = clarifications.entries
        .map((e) => '- ${e.key}: ${e.value}')
        .join('\n');
    
    return '''
Create a high-quality, professional, and unambiguous AI-ready instruction.

ORIGINAL VAGUE INSTRUCTION: "$originalInstruction"

USER CLARIFICATIONS:
$clarificationsText

Your task:
1. Merge the original intent with the detailed clarifications.
2. Produce a "Clarified" version that is specific, actionable, and formatted for a high-end LLM.
3. Use a professional, authoritative tone.
4. Ensure the "Structured Breakdown" is extremely detailed and provides extra context that a human might miss.

Respond ONLY in this JSON format:
{
  "original": "$originalInstruction",
  "clarified": "<Detailed paragraph with specific metrics, style, and constraints>",
  "improvements": {
    "before": "<Specific list of what was missing>",
    "after": "<List of exact parameters added>"
  },
  "structured": {
    "goal": "<Clear primary objective>",
    "style": "<Detailed visual/tonal direction>",
    "constraints": ["3-5 specific technical or content constraints"],
    "expectedOutcome": "<Clear definition of success>"
  }
}

Example:
{
  "original": "Make a professional website",
  "clarified": "Develop a high-conversion, modern startup landing page for a B2B SaaS product. Use a 'quiet luxury' aesthetic featuring a minimal color palette of deep navy, slate gray, and crisp white. Prioritize bold, readable typography (Sans-Serif) and ensure a mobile-first responsive architecture.",
  "improvements": {
    "before": "Lacked industry context, color palette, and typography specs.",
    "after": "Added B2B SaaS focus, specific colors, and typography direction."
  },
  "structured": {
    "goal": "Build a premium B2B SaaS landing page",
    "style": "Modern 'quiet luxury' with minimal colors and bold typography",
    "constraints": ["Mobile-first responsive layout", "3-color conservative palette", "High contrast"],
    "expectedOutcome": "A professional, high-trust landing page ready for handoff."
  }
}
''';
  }
}
