import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../models/final_output.dart';

class BeforeAfterView extends StatelessWidget {
  final FinalOutput output;

  const BeforeAfterView({
    super.key,
    required this.output,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Before/After Header
        Row(
          children: [
            Expanded(
              child: _SectionLabel(
                label: 'BEFORE',
                color: AppColors.error.withOpacity(0.7),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward,
              color: AppColors.primary,
              size: 24,
            ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(delay: 1000.ms, duration: 1500.ms),
            const SizedBox(width: 16),
            Expanded(
              child: _SectionLabel(
                label: 'AFTER',
                color: AppColors.success,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Comparison Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ComparisonCard(
                title: 'Original',
                content: output.original,
                color: AppColors.error.withOpacity(0.1),
                borderColor: AppColors.error.withOpacity(0.3),
                isDark: isDark,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ComparisonCard(
                title: 'Clarified',
                content: output.clarified,
                color: AppColors.success.withOpacity(0.1),
                borderColor: AppColors.success.withOpacity(0.3),
                isDark: isDark,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _SectionLabel({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTypography.overline.copyWith(color: color),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final Color borderColor;
  final bool isDark;

  const _ComparisonCard({
    required this.title,
    required this.content,
    required this.color,
    required this.borderColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: borderColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              height: 1.6,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }
}
