import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/entities/session_entity.dart';
import '../../core/entities/session_step_entity.dart';
import '../bloc/session_bloc.dart';
import '../../../../utility/style/app_colors.dart';

/// Navigation controls for session steps (Previous, Next, Complete)
class SessionNavigationControls extends StatelessWidget {
  final SessionEntity session;
  final GlobalKey<FormState>? formKey;

  const SessionNavigationControls({
    Key? key,
    required this.session,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLastStep = session.currentStep == session.steps.length - 1;
    void handleNext() {
      // Block if last step is a quiz and validation fails
      final currentStep = session.steps[session.currentStep];
      if (isLastStep && currentStep.type == SessionStepType.quiz) {
        final isValid = formKey?.currentState?.validate() ?? true;
        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى تعبئة الحقول المطلوبة')),
          );
          return;
        }
      }
      if (isLastStep) {
        context.read<SessionBloc>().completeSession();
      } else {
        context.read<SessionBloc>().nextStep();
      }
    }

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
            if(session.canGoPrevious)
              Expanded(
              child: _PreviousButton(
                onPressed: () => context.read<SessionBloc>().previousStep(),
              ),
            ),

            if(session.canGoNext||!session.steps[session.currentStep].isCompleted)const SizedBox(width: 12),

            // Next button
            if(session.canGoNext||!session.steps[session.currentStep].isCompleted)Expanded(
              child: _NextButton(
                isLastStep: isLastStep,
                onPressed: handleNext,
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
  final VoidCallback onPressed;

  const _PreviousButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back, size: 18),
      label: const Text('السابق'),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
  final bool isLastStep;
  final VoidCallback onPressed;


  const _NextButton({
    required this.isLastStep,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isLastStep ? 'إنهاء' : 'التالي';
    final buttonIcon = isLastStep ? Icons.flag : Icons.arrow_forward;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isLastStep ? AppColors.successColor : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(buttonText),
          const SizedBox(width: 8),
          Icon(buttonIcon, size: 18),
        ],
      ),
    );
  }
}
