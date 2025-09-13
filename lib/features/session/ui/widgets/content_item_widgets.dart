import 'dart:developer';

import 'package:flutter/material.dart';
import '../../core/entities/content_item_entity.dart';
import '../../../../utility/style/app_colors.dart';

/// Widget to render different types of content items
class ContentItemWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const ContentItemWidget({
    Key? key,
    required this.contentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (contentItem.type) {
      case ContentType.text:
        return _TextContentWidget(contentItem: contentItem);
      case ContentType.image:
        return _ImageContentWidget(contentItem: contentItem);
      case ContentType.video:
        return _VideoContentWidget(contentItem: contentItem);
    }
  }
}

/// Widget for text content
class _TextContentWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const _TextContentWidget({required this.contentItem});

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

/// Widget for image content
class _ImageContentWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const _ImageContentWidget({required this.contentItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              contentItem.content,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'فشل في تحميل الصورة',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              },
            ),
            // if (contentItem.caption != null)
            //   Container(
            //     padding: const EdgeInsets.all(12),
            //     color: Theme.of(context).cardColor,
            //     child: Text(
            //       contentItem.caption!,
            //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
            //         color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            //         fontStyle: FontStyle.italic,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

/// Widget for video content
class _VideoContentWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const _VideoContentWidget({required this.contentItem});

  @override
  Widget build(BuildContext context) {
    final durationSeconds = contentItem.metadata?['duration'] as int?;
    final durationText = durationSeconds != null
        ? '${(durationSeconds ~/ 60).toString().padLeft(2, '0')}:${(durationSeconds % 60).toString().padLeft(2, '0')}'
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video thumbnail placeholder
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade800,
                    child: Icon(
                      Icons.video_library,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  // Play button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement video player
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم تشغيل الفيديو قريباً'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  // Duration badge
                  if (durationText != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          durationText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (contentItem.caption != null)
              Container(
                padding: const EdgeInsets.all(12),
                color: Theme.of(context).cardColor,
                child: Text(
                  contentItem.caption!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
