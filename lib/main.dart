import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: InstructionClarifierApp(),
    ),
  );
}

class InstructionClarifierApp extends ConsumerWidget {
  const InstructionClarifierApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Instruction Clarifier AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const InputScreen(),
    );
  }
}
