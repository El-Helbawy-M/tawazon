import 'content_item_entity.dart';

/// Individual step within a session
class SessionStepEntity {
  final String id;
  final String title;
  final List<ContentItemEntity> contentItems;
  final SessionStepType type;
  final Map<String, dynamic>? metadata;
  final bool isCompleted;

  const SessionStepEntity({
    required this.id,
    required this.title,
    required this.contentItems,
    required this.type,
    this.metadata,
    required this.isCompleted,
  });

  SessionStepEntity copyWith({
    String? id,
    String? title,
    List<ContentItemEntity>? contentItems,
    SessionStepType? type,
    Map<String, dynamic>? metadata,
    bool? isCompleted,
  }) {
    return SessionStepEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      contentItems: contentItems ?? this.contentItems,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum SessionStepType {
  introduction,
  content,
  summary,
  conclusion,
}
