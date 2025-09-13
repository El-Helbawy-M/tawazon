import 'package:equatable/equatable.dart';

/// Enum for different content types
enum ContentType {
  text,
  image,
  video,
}

/// Entity representing a single content item within a session step
class ContentItemEntity extends Equatable {
  final String id;
  final ContentType type;
  final String content; // For text: the text content, for image/video: the URL/path
  final String? caption; // Optional caption for images and videos
  final Map<String, dynamic>? metadata; // Additional metadata (e.g., duration for videos, alt text for images)

  const ContentItemEntity({
    required this.id,
    required this.type,
    required this.content,
    this.caption,
    this.metadata,
  });

  /// Creates a text content item
  factory ContentItemEntity.text( {
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

  @override
  List<Object?> get props => [id, type, content, caption, metadata];

  @override
  String toString() {
    return 'ContentItemEntity(id: $id, type: $type, content: $content, caption: $caption, metadata: $metadata)';
  }
}
