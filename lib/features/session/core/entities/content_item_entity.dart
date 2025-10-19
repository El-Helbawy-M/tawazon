import 'package:equatable/equatable.dart';

/// Enum for different content types
enum ContentType {
  text,
  image,
  video,
  inputText,
  inputLongText,
  singleSelect,
}

/// Entity representing a single content item within a session step
class ContentItemEntity extends Equatable {
  final String id;
  final ContentType type;
  final String
      content; // For text: the text content, for image/video: the URL/path
  final String? caption; // Optional caption for images and videos
  final Map<String, dynamic>?
      metadata; // Additional metadata (e.g., duration for videos, alt text for images)

  const ContentItemEntity({
    required this.id,
    required this.type,
    required this.content,
    this.caption,
    this.metadata,
  });

  /// Creates a text content item
  factory ContentItemEntity.text({
    required String id,
    required String content,
    String? title,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.text,
      content: content,
      metadata: title != null ? {'title': title} : null,
    );
  }

  /// Creates an image content item
  factory ContentItemEntity.image({
    required String id,
    required String imageUrl,
    String? caption,
    String? altText,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.image,
      content: imageUrl,
      caption: caption,
      metadata: altText != null ? {'altText': altText} : null,
    );
  }

  /// Creates a video content item
  factory ContentItemEntity.video({
    required String id,
    required String videoUrl,
    String? caption,
    int? durationSeconds,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.video,
      content: videoUrl,
      caption: caption,
      metadata: durationSeconds != null ? {'duration': durationSeconds} : null,
    );
  }

  /// Creates an input text content item
  ///
  /// metadata keys used by UI layer:
  /// - label: String? (field label)
  /// - hint: String? (placeholder)
  /// - maxLength: int? (optional max length)
  /// - required: bool? (whether input is required)
  factory ContentItemEntity.inputText({
    required String id,
    String? initialValue,
    String? label,
    String? hint,
    int? maxLength,
    bool? required,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.inputText,
      content: initialValue ?? '',
      metadata: {
        if (label != null) 'label': label,
        if (hint != null) 'hint': hint,
        if (maxLength != null) 'maxLength': maxLength,
        if (required != null) 'required': required,
      },
    );
  }

  /// Creates an input long text (multiline) content item suitable for descriptions
  ///
  /// metadata keys used by UI layer:
  /// - label: String? (field label)
  /// - hint: String? (placeholder)
  /// - maxLength: int? (optional max length)
  /// - required: bool? (whether input is required)
  /// - minLines: int? (minimum visible lines, default handled by UI)
  /// - maxLines: int? (maximum visible lines, default handled by UI)
  factory ContentItemEntity.inputLongText({
    required String id,
    String? initialValue,
    String? label,
    String? hint,
    int? maxLength,
    bool? required,
    int? minLines,
    int? maxLines,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.inputLongText,
      content: initialValue ?? '',
      metadata: {
        if (label != null) 'label': label,
        if (hint != null) 'hint': hint,
        if (maxLength != null) 'maxLength': maxLength,
        if (required != null) 'required': required,
        if (minLines != null) 'minLines': minLines,
        if (maxLines != null) 'maxLines': maxLines,
      },
    );
  }

  /// Creates a single select content item
  ///
  /// metadata keys used by UI layer:
  /// - label: String? (field label)
  /// - hint: String? (placeholder)
  /// - options: List<Map<String,String>> with keys: value, label
  /// - selected: String? (currently selected value)
  factory ContentItemEntity.singleSelect({
    required String id,
    required List<Map<String, String>> options,
    String? selected,
    String? label,
    String? hint,
    bool? required,
  }) {
    return ContentItemEntity(
      id: id,
      type: ContentType.singleSelect,
      content: '',
      metadata: {
        'options': options,
        if (selected != null) 'selected': selected,
        if (label != null) 'label': label,
        if (hint != null) 'hint': hint,
        if (required != null) 'required': required,
      },
    );
  }

  @override
  List<Object?> get props => [id, type, content, caption, metadata];

  @override
  String toString() {
    return 'ContentItemEntity(id: $id, type: $type, content: $content, caption: $caption, metadata: $metadata)';
  }
}
