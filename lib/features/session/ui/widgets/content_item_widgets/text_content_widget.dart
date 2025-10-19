import 'package:flutter/material.dart';
import '../../../core/entities/content_item_entity.dart';

/// Widget for text content
class TextContentWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const TextContentWidget({required this.contentItem});

  @override
  Widget build(BuildContext context) {
    final title = contentItem.metadata?['title'] as String?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            contentItem.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
