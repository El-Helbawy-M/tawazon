import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/entities/session_entity.dart';
import '../bloc/session_bloc.dart';
import '../../../../utility/style/app_colors.dart';

/// Navigation controls for session steps (Previous, Next, Complete)
class SessionNavigationControls extends StatelessWidget {
  final SessionEntity session;

  const SessionNavigationControls({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            Expanded(
              child: _PreviousButton(
                canGoPrevious: session.canGoPrevious,
                onPressed: () => context.read<SessionBloc>().previousStep(),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Next button
            Expanded(
              child: _NextButton(
                canGoNext: session.canGoNext,
                isLastStep: session.currentStep == session.steps.length - 1,
                onPressed: () => context.read<SessionBloc>().nextStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Previous step button
class _PreviousButton extends StatelessWidget {
  final bool canGoPrevious;
  final VoidCallback onPressed;

  const _PreviousButton({
    required this.canGoPrevious,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: canGoPrevious ? onPressed : null,
      icon: const Icon(Icons.arrow_back, size: 18),
      label: const Text('السابق'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


/// Next step button
class _NextButton extends StatelessWidget {
  final bool canGoNext;
  final bool isLastStep;
  final VoidCallback onPressed;

  const _NextButton({
    required this.canGoNext,
    required this.isLastStep,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isLastStep ? 'إنهاء' : 'التالي';
    final buttonIcon = isLastStep ? Icons.flag : Icons.arrow_forward;

    return ElevatedButton.icon(
      onPressed: canGoNext ? onPressed : null,
      icon: Icon(buttonIcon, size: 18),
      label: Text(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLastStep 
            ? AppColors.successColor 
            : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
