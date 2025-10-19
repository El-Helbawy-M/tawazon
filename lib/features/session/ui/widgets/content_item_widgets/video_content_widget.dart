import 'package:flutter/material.dart';
import '../../../../../utility/style/app_colors.dart';
import '../../../core/entities/content_item_entity.dart';

class VideoContentWidget extends StatelessWidget {
  final ContentItemEntity contentItem;

  const VideoContentWidget({super.key, required this.contentItem});

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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
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
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7),
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
