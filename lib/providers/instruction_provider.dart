import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instruction.dart';
import '../models/ambiguity_analysis.dart';
import '../models/clarification_option.dart';
import '../models/final_output.dart';
import '../services/ai_service.dart';
import '../services/demo_service.dart';

// Demo mode provider
final demoModeProvider = StateProvider<bool>((ref) => false);

// AI Service provider
final aiServiceProvider = Provider<AiService>((ref) {
  // Try to get from environment first
  var geminiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  var groqKey = const String.fromEnvironment('GROQ_API_KEY', defaultValue: '');
  
  // Fallback for Gemini
  if (geminiKey.isEmpty) {
    geminiKey = 'AIzaSyAsN8iWKDaY67BdLh6HLOmxPVHlr1VxplE';
  }

  // Fallback for Groq (placeholder - needs to be replaced with real key)
  if (groqKey.isEmpty) {
    groqKey = 'gsk_PLACEHOLDER_GROQ_KEY';
  }
  
  return AiService(
    geminiApiKey: geminiKey,
    groqApiKey: groqKey,
  );
});

// Current instruction provider
final currentInstructionProvider =
    StateProvider<Instruction?>((ref) => null);

// Ambiguity analysis provider
final ambiguityAnalysisProvider =
    StateProvider<AmbiguityAnalysis?>((ref) => null);

// Current clarification question provider
final clarificationQuestionProvider =
    StateProvider<ClarificationQuestion?>((ref) => null);

// Selected clarifications (aspect -> value mapping)
final selectedClarificationsProvider =
    StateProvider<Map<String, String>>((ref) => {});

// Final output provider
final finalOutputProvider = StateProvider<FinalOutput?>((ref) => null);

// Loading state provider
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error provider
final errorProvider = StateProvider<String?>((ref) => null);

// Analyze ambiguity action
final analyzeAmbiguityProvider =
    FutureProvider.family<AmbiguityAnalysis, String>((ref, instruction) async {
  final isDemoMode = ref.read(demoModeProvider);
  
  if (isDemoMode) {
    // Use demo data
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return DemoService.getDemoAnalysis(instruction);
  } else {
    // Use real AI
    final aiService = ref.read(aiServiceProvider);
    return await aiService.analyzeAmbiguity(instruction);
  }
});

// Generate clarifications action
final generateClarificationsProvider = FutureProvider.family<
    ClarificationQuestion,
    ({String instruction, AmbiguityAnalysis analysis})>((ref, params) async {
  final isDemoMode = ref.read(demoModeProvider);
  
  if (isDemoMode) {
    await Future.delayed(const Duration(milliseconds: 500));
    return DemoService.getDemoClarification(params.instruction);
  } else {
    final aiService = ref.read(aiServiceProvider);
    return await aiService.generateClarifications(
      params.instruction,
      params.analysis,
    );
  }
});

// Generate final instruction action
final generateFinalInstructionProvider = FutureProvider.family<FinalOutput,
    ({String instruction, Map<String, String> clarifications})>(
  (ref, params) async {
    final isDemoMode = ref.read(demoModeProvider);
    
    if (isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      // Get first clarification value for demo
      final selectedValue =
          params.clarifications.values.isNotEmpty
              ? params.clarifications.values.first
              : 'default';
      return DemoService.getDemoOutput(params.instruction, selectedValue);
    } else {
      final aiService = ref.read(aiServiceProvider);
      return await aiService.generateFinalInstruction(
        params.instruction,
        params.clarifications,
      );
    }
  },
);
