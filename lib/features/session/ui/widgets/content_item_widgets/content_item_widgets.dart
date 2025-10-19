import 'package:flutter/material.dart';
import '../../../core/entities/content_item_entity.dart';
import 'text_content_widget.dart';
import 'image_content_widget.dart';
import 'video_content_widget.dart';
import 'input_text_content_widget.dart';
import 'input_long_text_content_widget.dart';
import 'single_select_content_widget.dart';

/// Widget to render different types of content items
class ContentItemWidget extends StatelessWidget {
  final ContentItemEntity contentItem;
  final String stepId;

  const ContentItemWidget({
    Key? key,
    required this.stepId,
    required this.contentItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (contentItem.type) {
      case ContentType.text:
        return TextContentWidget(contentItem: contentItem);
      case ContentType.image:
        return ImageContentWidget(contentItem: contentItem);
      case ContentType.video:
        return VideoContentWidget(contentItem: contentItem);
      case ContentType.inputText:
        return InputTextContentWidget(stepId: stepId, contentItem: contentItem);
      case ContentType.inputLongText:
        return InputLongTextContentWidget(stepId: stepId, contentItem: contentItem);
      case ContentType.singleSelect:
        return SingleSelectContentWidget(stepId: stepId, contentItem: contentItem);
    }
  }
}
