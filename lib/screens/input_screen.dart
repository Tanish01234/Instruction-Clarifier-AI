import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../widgets/custom_button.dart';
import '../providers/instruction_provider.dart';
import '../models/instruction.dart';
import '../services/demo_service.dart';
import 'ambiguity_screen.dart';

class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  final TextEditingController _controller = TextEditingController();
  int _currentPlaceholderIndex = 0;
  bool _hasText = false; // Track if text field has content

  final List<String> _placeholders = [
    "Make a professional website",
    "Create a smart AI assistant",
    "Simple but impactful design",
    "Startup-type design chahiye",
  ];

  @override
  void initState() {
    super.initState();
    // Listen to text changes
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final instruction = _controller.text.trim();
    if (instruction.isEmpty) return;

    // Create instruction object
    final inst = Instruction(
      originalText: instruction,
      timestamp: DateTime.now(),
    );

    // Store in provider
    ref.read(currentInstructionProvider.notifier).state = inst;

    // Navigate to ambiguity screen
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AmbiguityScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDemoMode = ref.watch(demoModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with demo toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_horizontal.png',
                      height: 40,
                    ).animate().fadeIn(duration: 300.ms),
                    Row(
                      children: [
                        Text(
                          'Demo',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: isDemoMode,
                          onChanged: (value) {
                            ref.read(demoModeProvider.notifier).state = value;
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
                
                const SizedBox(height: 40), // Replace first Spacer
              
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'AI that fixes how',
                    style: AppTypography.h1.copyWith(
                      fontSize: 36,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                  
                  Text(
                    'humans talk to machines',
                    style: AppTypography.h1.copyWith(
                      fontSize: 36,
                      height: 1.2,
                      color: AppColors.primary,
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Turn vague instructions into clear, executable ones',
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                  
                  const SizedBox(height: 48),
                  
                  // Input card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe what you want',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        TextField(
                          controller: _controller,
                          maxLines: 4,
                          style: AppTypography.bodyLarge,
                          decoration: InputDecoration(
                            hintText: _placeholders[_currentPlaceholderIndex],
                            border: InputBorder.none,
                            filled: false,
                          ),
                          onSubmitted: (_) => _handleSubmit(),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Quick fill examples (demo mode)
                        if (isDemoMode) ...[
                          const Divider(),
                          const SizedBox(height: 12),
                          Text(
                            'Quick Examples:',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: DemoService.demoInstructions.map((example) {
                              return GestureDetector(
                                onTap: () {
                                  _controller.text = example;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    example,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  CustomButton(
                    text: 'Analyze Instruction',
                    onPressed: _hasText ? _handleSubmit : null,
                    icon: Icons.psychology,
                  ).animate().fadeIn(delay: 1100.ms),
                ],
              ),
              
              const SizedBox(height: 40), // Replace second Spacer
              
              // Tagline
              Center(
                child: Text(
                  '"We didn\'t make AI smarter.\nWe made human instructions clearer."',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    fontStyle: FontStyle.italic,
                    color: (isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary)
                        .withOpacity(0.6),
                  ),
                ),
              ).animate().fadeIn(delay: 1300.ms),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
