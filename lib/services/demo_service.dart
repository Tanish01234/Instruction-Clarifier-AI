import '../models/ambiguity_analysis.dart';
import '../models/clarification_option.dart';
import '../models/final_output.dart';

class DemoService {
  // Pre-cached demo data for offline hackathon demos
  
  static const demoInstructions = [
    "Make it more professional",
    "Simple but impactful design",
    "Startup-type design chahiye",
    "Create a smart AI assistant",
  ];
  
  static AmbiguityAnalysis getDemoAnalysis(String instruction) {
    // Pre-cached analysis for demo mode
    final analyses = {
      "Make it more professional": AmbiguityAnalysis(
        score: 85,
        severity: "High",
        vagueWords: ["professional"],
        explanation:
            "The word 'professional' can mean 3-4 different things depending on industry, audience, and context.",
        missingConstraints: [
          "target audience",
          "visual style",
          "industry context",
          "scope"
        ],
      ),
      "Simple but impactful design": AmbiguityAnalysis(
        score: 72,
        severity: "High",
        vagueWords: ["simple", "impactful"],
        explanation:
            "'Simple' and 'impactful' are subjective terms that can vary greatly across different design contexts.",
        missingConstraints: [
          "design medium",
          "target audience",
          "brand personality",
          "constraints"
        ],
      ),
      "Startup-type design chahiye": AmbiguityAnalysis(
        score: 78,
        severity: "High",
        vagueWords: ["startup-type"],
        explanation:
            "Startup aesthetics range from minimalist to bold, tech-heavy to creative, requiring clarification.",
        missingConstraints: [
          "visual style preference",
          "color scheme",
          "typography direction",
          "platform"
        ],
      ),
      "Create a smart AI assistant": AmbiguityAnalysis(
        score: 68,
        severity: "Medium",
        vagueWords: ["smart"],
        explanation:
            "The definition of 'smart' varies widely - from basic automation to advanced ML capabilities.",
        missingConstraints: [
          "capabilities scope",
          "use case",
          "technical requirements",
          "integration needs"
        ],
      ),
    };
    
    return analyses[instruction] ??
        AmbiguityAnalysis(
          score: 50,
          severity: "Medium",
          vagueWords: [],
          explanation: "Some ambiguity detected in this instruction.",
          missingConstraints: ["context", "constraints"],
        );
  }
  
  static ClarificationQuestion getDemoClarification(String instruction) {
    final clarifications = {
      "Make it more professional": ClarificationQuestion(
        aspect: "style",
        question: "What do you mean by 'professional'?",
        options: [
          ClarificationOption(
            id: "1",
            title: "Corporate & Formal",
            description: "Suits, ties, conservative colors, traditional layouts",
            value: "corporate-formal",
          ),
          ClarificationOption(
            id: "2",
            title: "Modern Startup-style",
            description: "Bold, clean, innovative vibe, tech-forward",
            value: "modern-startup",
          ),
          ClarificationOption(
            id: "3",
            title: "Creative & Visual-heavy",
            description: "Artistic, unique, expressive, design-focused",
            value: "creative-visual",
          ),
        ],
      ),
      "Simple but impactful design": ClarificationQuestion(
        aspect: "style",
        question: "What type of 'simple' are you looking for?",
        options: [
          ClarificationOption(
            id: "1",
            title: "Minimalist & Clean",
            description: "Maximum whitespace, minimal colors, understated",
            value: "minimalist-clean",
          ),
          ClarificationOption(
            id: "2",
            title: "Bold & Direct",
            description: "Clear messaging, strong visuals, high contrast",
            value: "bold-direct",
          ),
          ClarificationOption(
            id: "3",
            title: "Elegant & Refined",
            description: "Sophisticated, subtle details, premium feel",
            value: "elegant-refined",
          ),
        ],
      ),
      "Startup-type design chahiye": ClarificationQuestion(
        aspect: "style",
        question: "Which startup aesthetic do you prefer?",
        options: [
          ClarificationOption(
            id: "1",
            title: "Tech & Modern",
            description: "Gradients, dark modes, futuristic elements",
            value: "tech-modern",
          ),
          ClarificationOption(
            id: "2",
            title: "Clean & Minimal",
            description: "Airbnb/Stripe style, lots of whitespace",
            value: "clean-minimal",
          ),
          ClarificationOption(
            id: "3",
            title: "Bold & Energetic",
            description: "Bright colors, dynamic layouts, playful",
            value: "bold-energetic",
          ),
        ],
      ),
      "Create a smart AI assistant": ClarificationQuestion(
        aspect: "scope",
        question: "What level of 'smart' do you need?",
        options: [
          ClarificationOption(
            id: "1",
            title: "Basic Automation",
            description: "Simple Q&A, predefined responses, rule-based",
            value: "basic-automation",
          ),
          ClarificationOption(
            id: "2",
            title: "Conversational AI",
            description: "Natural language, context-aware, adaptive",
            value: "conversational-ai",
          ),
          ClarificationOption(
            id: "3",
            title: "Advanced Intelligence",
            description: "Learning, reasoning, multi-task capabilities",
            value: "advanced-intelligence",
          ),
        ],
      ),
    };
    
    return clarifications[instruction] ??
        ClarificationQuestion(
          aspect: "general",
          question: "What is your main priority?",
          options: [
            ClarificationOption(
              id: "1",
              title: "Speed",
              description: "Fast delivery, quick results",
              value: "speed",
            ),
            ClarificationOption(
              id: "2",
              title: "Quality",
              description: "High attention to detail",
              value: "quality",
            ),
            ClarificationOption(
              id: "3",
              title: "Innovation",
              description: "Unique, creative approach",
              value: "innovation",
            ),
          ],
        );
  }
  
  static FinalOutput getDemoOutput(
    String instruction,
    String selectedValue,
  ) {
    // Example outputs based on instruction + selection
    final outputs = {
      "Make it more professional_modern-startup": FinalOutput(
        original: "Make it more professional",
        clarified:
            "Design a modern startup-style professional interface with bold typography, clean layouts, tech-forward aesthetic, minimal color palette (max 3 colors), and clear user-focused call-to-action elements.",
        improvements: {
          "before":
              "Unclear what 'professional' meant - could be corporate, creative, or tech-focused",
          "after":
              "Specified modern startup aesthetic with typography, color, and layout constraints"
        },
        structured: StructuredInstruction(
          goal: "Create a professional interface for a tech startup",
          style:
              "Modern startup aesthetic with bold typography and minimal colors",
          constraints: [
            "Maximum 3 colors",
            "Bold sans-serif typography",
            "Clean layouts with generous whitespace",
            "Mobile-first responsive design"
          ],
          expectedOutcome:
              "A professional interface that feels innovative and tech-forward, appealing to modern audiences",
        ),
      ),
      "Simple but impactful design_minimalist-clean": FinalOutput(
        original: "Simple but impactful design",
        clarified:
            "Create a minimalist design with maximum whitespace, single accent color, large typography for key messages, and strategic use of negative space to create visual impact through restraint.",
        improvements: {
          "before": "Ambiguous what 'simple' and 'impactful' meant",
          "after":
              "Defined minimalist approach with specific constraints on whitespace and color"
        },
        structured: StructuredInstruction(
          goal: "Design with minimal elements but maximum visual impact",
          style: "Minimalist with abundant whitespace and restraint",
          constraints: [
            "Single accent color only",
            "Maximum 3 visual elements per section",
            "Large typography (min 48px headlines)",
            "80% whitespace coverage"
          ],
          expectedOutcome:
              "A design that feels spacious, calm, yet memorable through strategic visual hierarchy",
        ),
      ),
    };
    
    final key = "${instruction}_$selectedValue";
    return outputs[key] ??
        FinalOutput(
          original: instruction,
          clarified:
              "Create a clear, well-defined solution based on: $selectedValue",
          improvements: {
            "before": "Instruction was vague",
            "after": "Added specific constraints and direction"
          },
          structured: StructuredInstruction(
            goal: "Execute the clarified instruction",
            style: selectedValue,
            constraints: ["Based on selection"],
            expectedOutcome: "A clear result matching the clarification",
          ),
        );
  }
}
