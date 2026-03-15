import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../widgets/custom_button.dart';
import '../widgets/clarification_card.dart';
import '../providers/instruction_provider.dart';
import '../models/clarification_option.dart';
import 'output_screen.dart';

class ClarificationScreen extends ConsumerStatefulWidget {
  const ClarificationScreen({super.key});

  @override
  ConsumerState<ClarificationScreen> createState() =>
      _ClarificationScreenState();
}

class _ClarificationScreenState extends ConsumerState<ClarificationScreen> {
  ClarificationQuestion? _question;
  String? _selectedOptionId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateClarifications();
  }

  Future<void> _generateClarifications() async {
    final instruction = ref.read(currentInstructionProvider);
    final analysis = ref.read(ambiguityAnalysisProvider);

    if (instruction == null || analysis == null) return;

    setState(() => _isLoading = true);

    try {
      final question = await ref.read(
        generateClarificationsProvider((
          instruction: instruction.originalText,
          analysis: analysis,
        )).future,
      );

      ref.read(clarificationQuestionProvider.notifier).state = question;

      setState(() {
        _question = question;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating clarifications: $e')),
        );
      }
    }
  }

  void _handleContinue() async {
    if (_selectedOptionId == null || _question == null) return;

    final selectedOption = _question!.options.firstWhere(
      (opt) => opt.id == _selectedOptionId,
    );

    // Store clarification
    final clarifications = {
      _question!.aspect: selectedOption.value,
    };

    ref.read(selectedClarificationsProvider.notifier).state = clarifications;

    // Navigate to output
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OutputScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Generating clarification options...',
                style: AppTypography.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    if (_question == null) {
      return const Scaffold(
        body: Center(
          child: Text('No clarification question available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Clarify Details', style: AppTypography.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CLARIFICATION NEEDED',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _question!.question,
                      style: AppTypography.h2.copyWith(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 32),

              // Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _question!.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClarificationCard(
                          option: option,
                          isSelected: _selectedOptionId == option.id,
                          onTap: () {
                            setState(() {
                              _selectedOptionId = option.id;
                            });
                          },
                        ).animate(delay: (300 + index * 150).ms),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Continue button
              CustomButton(
                text: 'Continue',
                onPressed: _selectedOptionId != null ? _handleContinue : null,
                icon: Icons.arrow_forward,
              ).animate().fadeIn(delay: 900.ms),
            ],
          ),
        ),
      ),
    );
  }
}
