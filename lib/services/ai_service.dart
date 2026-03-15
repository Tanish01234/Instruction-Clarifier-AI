import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../models/ambiguity_analysis.dart';
import '../models/clarification_option.dart';
import '../models/final_output.dart';
import '../core/utils/ai_prompts.dart';

class AiService {
  late final GenerativeModel _geminiModel;
  final String geminiApiKey;
  final String groqApiKey;
  
  AiService({required this.geminiApiKey, required this.groqApiKey}) {
    _geminiModel = GenerativeModel(
      model: 'gemini-flash-latest', 
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1000,
      ),
    );
  }

  /// Call Groq using REST API
  Future<String> _callGroq(String prompt) async {
    const groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
    
    try {
      final response = await http.post(
        Uri.parse(groqUrl),
        headers: {
          'Authorization': 'Bearer $groqApiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Groq API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to call Groq: $e');
    }
  }
  
  /// Stage 1: Analyze instruction for ambiguity
  Future<AmbiguityAnalysis> analyzeAmbiguity(String instruction) async {
    final prompt = AiPrompts.getAnalysisPrompt(instruction);
    
    try {
      // Try Gemini first
      final response = await _geminiModel.generateContent([Content.text(prompt)]);
      if (response.text == null) throw Exception('Empty response from Gemini');
      
      final jsonResponse = json.decode(response.text!);
      return AmbiguityAnalysis.fromJson(jsonResponse);
    } catch (e) {
      print('Gemini failed, falling back to Groq: $e');
      // Fallback to Groq
      final groqResponse = await _callGroq(prompt);
      final jsonResponse = json.decode(groqResponse);
      return AmbiguityAnalysis.fromJson(jsonResponse);
    }
  }
  
  /// Stage 2: Generate clarification options
  Future<ClarificationQuestion> generateClarifications(
    String instruction,
    AmbiguityAnalysis analysis,
  ) async {
    final prompt = AiPrompts.getClarificationPrompt(
      instruction,
      analysis.missingConstraints.isNotEmpty
          ? analysis.missingConstraints.first
          : 'general clarity',
      analysis.vagueWords,
    );
    
    try {
      // Try Gemini first
      final response = await _geminiModel.generateContent([Content.text(prompt)]);
      if (response.text == null) throw Exception('Empty response from Gemini');
      
      final jsonResponse = json.decode(response.text!);
      return ClarificationQuestion.fromJson(jsonResponse);
    } catch (e) {
      print('Gemini failed, falling back to Groq: $e');
      // Fallback to Groq
      final groqResponse = await _callGroq(prompt);
      final jsonResponse = json.decode(groqResponse);
      return ClarificationQuestion.fromJson(jsonResponse);
    }
  }
  
  /// Stage 3: Generate final clarified instruction
  Future<FinalOutput> generateFinalInstruction(
    String originalInstruction,
    Map<String, String> clarifications,
  ) async {
    final prompt = AiPrompts.getFinalInstructionPrompt(
      originalInstruction,
      clarifications,
    );
    
    try {
      // Try Gemini first
      final response = await _geminiModel.generateContent([Content.text(prompt)]);
      if (response.text == null) throw Exception('Empty response from Gemini');
      
      final jsonResponse = json.decode(response.text!);
      return FinalOutput.fromJson(jsonResponse);
    } catch (e) {
      print('Gemini failed, falling back to Groq: $e');
      // Fallback to Groq
      final groqResponse = await _callGroq(prompt);
      final jsonResponse = json.decode(groqResponse);
      return FinalOutput.fromJson(jsonResponse);
    }
  }
}
