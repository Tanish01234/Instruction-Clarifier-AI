import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../widgets/custom_button.dart';
import '../widgets/ambiguity_meter.dart';
import '../providers/instruction_provider.dart';
import '../models/ambiguity_analysis.dart';
import 'clarification_screen.dart';

class AmbiguityScreen extends ConsumerStatefulWidget {
  const AmbiguityScreen({super.key});

  @override
  ConsumerState<AmbiguityScreen> createState() => _AmbiguityScreenState();
}

class _AmbiguityScreenState extends ConsumerState<AmbiguityScreen> {
  AmbiguityAnalysis? _analysis;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analyzeInstruction();
  }

  Future<void> _analyzeInstruction() async {
    final instruction = ref.read(currentInstructionProvider);
    if (instruction == null) return;

    setState(() => _isLoading = true);

    try {
      final analysis = await ref.read(
        analyzeAmbiguityProvider(instruction.originalText).future,
      );

      ref.read(ambiguityAnalysisProvider.notifier).state = analysis;

      setState(() {
        _analysis = analysis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing instruction: $e')),
        );
      }
    }
  }

  void _handleContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ClarificationScreen(),
      ),
    );
  }

  Widget _buildVagueWordChip(String word, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.highlightVague.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.highlightVague.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.highlightVague,
          ),
          const SizedBox(width: 6),
          Text(
            word,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.highlightVague,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instruction = ref.watch(currentInstructionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Analyzing your instruction...',
                style: AppTypography.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (_analysis == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Analysis Failed',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  'The Gemini API requires an API key. For the hackathon demo, we recommend using Demo Mode.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Enable Demo Mode & Retry',
                  onPressed: () {
                    ref.read(demoModeProvider.notifier).state = true;
                    _analyzeInstruction();
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Go Back',
                  type: ButtonType.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo_horizontal.png', height: 28),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Original instruction card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.warning.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.text_snippet,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'YOUR INSTRUCTION',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      instruction?.originalText ?? '',
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 32),

              // Ambiguity meter
              Center(
                child: AmbiguityMeter(
                  score: _analysis!.score,
                  severity: _analysis!.severity,
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 32),

              // Explanation card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'WHY IS THIS AMBIGUOUS?',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _analysis!.explanation,
                      style: AppTypography.bodyMedium.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 24),

              // Vague words
              if (_analysis!.vagueWords.isNotEmpty) ...[
                Text(
                  'Vague Words Detected',
                  style: AppTypography.h3,
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _analysis!.vagueWords
                      .map((word) => _buildVagueWordChip(word, isDark))
                      .toList(),
                ).animate().fadeIn(delay: 900.ms),
                const SizedBox(height: 24),
              ],

              // Missing constraints
              if (_analysis!.missingConstraints.isNotEmpty) ...[
                Text(
                  'Missing Information',
                  style: AppTypography.h3,
                ).animate().fadeIn(delay: 1000.ms),
                const SizedBox(height: 12),
                Column(
                  children: _analysis!.missingConstraints.map((constraint) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              constraint,
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 1100.ms),
                const SizedBox(height: 32),
              ],

              // Continue button
              CustomButton(
                text: 'Clarify Instruction',
                onPressed: _handleContinue,
                icon: Icons.arrow_forward,
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
