import 'package:flutter/material.dart';
import '../../core/entities/session_entity.dart';
import '../../core/entities/session_step_entity.dart';
import '../../../../utility/style/app_colors.dart';
import 'content_item_widgets.dart';

/// Widget that displays the content for the current session step
class SessionStepContent extends StatelessWidget {
  final SessionEntity session;
  final int currentStep;

  const SessionStepContent({
    Key? key,
    required this.session,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentStep >= session.steps.length) {
      return const Center(
        child: Text('خطوة غير صالحة'),
      );
    }

    final step = session.steps[currentStep];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step type indicator
          _StepTypeIndicator(stepType: step.type),
          
          const SizedBox(height: 16),
          
          // Step title
          Text(
            step.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Step content based on type
          _buildStepContent(step),
          
          const SizedBox(height: 24),
          
          // Completion status
          if (step.isCompleted)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.successColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.successColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تم إكمال هذه الخطوة',
                    style: TextStyle(
                      color: AppColors.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent(SessionStepEntity step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render all content items in sequence
        ...step.contentItems.map((contentItem) => 
          ContentItemWidget(contentItem: contentItem)
        ).toList(),
      ],
    );
  }
}

/// Step type indicator widget
class _StepTypeIndicator extends StatelessWidget {
  final SessionStepType stepType;

  const _StepTypeIndicator({required this.stepType});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String label;
    Color color;

    switch (stepType) {
      case SessionStepType.introduction:
        icon = Icons.play_circle_outline;
        label = 'مقدمة';
        color = Colors.blue;
        break;
      case SessionStepType.content:
        icon = Icons.menu_book;
        label = 'محتوى';
        color = Colors.green;
        break;
      case SessionStepType.summary:
        icon = Icons.summarize;
        label = 'ملخص';
        color = Colors.indigo;
        break;
      case SessionStepType.conclusion:
        icon = Icons.flag;
        label = 'خاتمة';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}



