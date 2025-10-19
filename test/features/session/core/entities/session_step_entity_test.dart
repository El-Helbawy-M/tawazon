import 'package:flutter_test/flutter_test.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';

void main() {
  group('SessionStepEntity', () {
    late SessionStepEntity tSessionStepEntity;
    late List<ContentItemEntity> tContentItems;

    setUp(() {
      tContentItems = [
        const ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample text content',
        ),
        const ContentItemEntity(
          id: 'content_2',
          type: ContentType.image,
          content: 'assets/images/sample.jpg',
          caption: 'Sample image',
        ),
      ];

      tSessionStepEntity = SessionStepEntity(
        id: 'step_1',
        title: 'Test Step',
        contentItems: tContentItems,
        type: SessionStepType.content,
        metadata: {'duration': 300, 'difficulty': 'medium'},
        isCompleted: false,
      );
    });

    group('constructor', () {
      test('should create a valid SessionStepEntity with required parameters', () {
        expect(tSessionStepEntity.id, 'step_1');
        expect(tSessionStepEntity.title, 'Test Step');
        expect(tSessionStepEntity.contentItems, tContentItems);
        expect(tSessionStepEntity.type, SessionStepType.content);
        expect(tSessionStepEntity.isCompleted, false);
        expect(tSessionStepEntity.metadata, {'duration': 300, 'difficulty': 'medium'});
      });

      test('should create SessionStepEntity without metadata', () {
        const stepWithoutMetadata = SessionStepEntity(
          id: 'step_2',
          title: 'Step Without Metadata',
          contentItems: [],
          type: SessionStepType.introduction,
          isCompleted: true,
        );

        expect(stepWithoutMetadata.metadata, isNull);
        expect(stepWithoutMetadata.isCompleted, true);
      });

      test('should create SessionStepEntity with empty content items', () {
        const stepWithEmptyContent = SessionStepEntity(
          id: 'step_3',
          title: 'Empty Step',
          contentItems: [],
          type: SessionStepType.summary,
          isCompleted: false,
        );

        expect(stepWithEmptyContent.contentItems, isEmpty);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated values', () {
        final updatedStep = tSessionStepEntity.copyWith(
          title: 'Updated Step Title',
          isCompleted: true,
        );

        expect(updatedStep.title, 'Updated Step Title');
        expect(updatedStep.isCompleted, true);
        expect(updatedStep.id, tSessionStepEntity.id);
        expect(updatedStep.contentItems, tSessionStepEntity.contentItems);
        expect(updatedStep.type, tSessionStepEntity.type);
        expect(updatedStep.metadata, tSessionStepEntity.metadata);
      });

      test('should return same instance when no parameters provided', () {
        final copiedStep = tSessionStepEntity.copyWith();

        expect(copiedStep.id, tSessionStepEntity.id);
        expect(copiedStep.title, tSessionStepEntity.title);
        expect(copiedStep.contentItems, tSessionStepEntity.contentItems);
        expect(copiedStep.type, tSessionStepEntity.type);
        expect(copiedStep.metadata, tSessionStepEntity.metadata);
        expect(copiedStep.isCompleted, tSessionStepEntity.isCompleted);
      });

      test('should update content items when provided', () {
        final newContentItems = [
          const ContentItemEntity(
            id: 'new_content',
            type: ContentType.video,
            content: 'assets/videos/sample.mp4',
          ),
        ];

        final updatedStep = tSessionStepEntity.copyWith(
          contentItems: newContentItems,
        );

        expect(updatedStep.contentItems, newContentItems);
        expect(updatedStep.contentItems.length, 1);
        expect(updatedStep.contentItems.first.type, ContentType.video);
      });

      test('should update metadata when provided', () {
        final newMetadata = {'newKey': 'newValue', 'updated': true};
        final updatedStep = tSessionStepEntity.copyWith(
          metadata: newMetadata,
        );

        expect(updatedStep.metadata, newMetadata);
      });

      test('should clear metadata when null is provided', () {
        final updatedStep = tSessionStepEntity.copyWith(
          metadata: null,
        );

        expect(updatedStep.metadata, isNull);
      });

      test('should update step type when provided', () {
        final updatedStep = tSessionStepEntity.copyWith(
          type: SessionStepType.conclusion,
        );

        expect(updatedStep.type, SessionStepType.conclusion);
      });
    });

    group('SessionStepType enum', () {
      test('should have all expected values', () {
        expect(SessionStepType.values, contains(SessionStepType.introduction));
        expect(SessionStepType.values, contains(SessionStepType.content));
        expect(SessionStepType.values, contains(SessionStepType.summary));
        expect(SessionStepType.values, contains(SessionStepType.conclusion));
      });

      test('should have correct number of enum values', () {
        expect(SessionStepType.values.length, 4);
      });
    });

    group('edge cases', () {
      test('should handle step with single content item', () {
        final singleContentStep = SessionStepEntity(
          id: 'single_content_step',
          title: 'Single Content Step',
          contentItems: [tContentItems.first],
          type: SessionStepType.introduction,
          isCompleted: false,
        );

        expect(singleContentStep.contentItems.length, 1);
        expect(singleContentStep.contentItems.first, tContentItems.first);
      });

      test('should handle step with large metadata', () {
        final largeMetadata = Map<String, dynamic>.fromIterable(
          List.generate(100, (index) => 'key_$index'),
          value: (key) => 'value_for_$key',
        );

        final stepWithLargeMetadata = SessionStepEntity(
          id: 'large_metadata_step',
          title: 'Large Metadata Step',
          contentItems: const [],
          type: SessionStepType.content,
          metadata: largeMetadata,
          isCompleted: false,
        );

        expect(stepWithLargeMetadata.metadata?.length, 100);
        expect(stepWithLargeMetadata.metadata?['key_0'], 'value_for_key_0');
        expect(stepWithLargeMetadata.metadata?['key_99'], 'value_for_key_99');
      });

      test('should handle step with mixed content types', () {
        final mixedContentItems = [
          const ContentItemEntity(
            id: 'text_content',
            type: ContentType.text,
            content: 'Text content',
          ),
          const ContentItemEntity(
            id: 'image_content',
            type: ContentType.image,
            content: 'image_url.jpg',
          ),
          const ContentItemEntity(
            id: 'video_content',
            type: ContentType.video,
            content: 'video_url.mp4',
          ),
        ];

        final mixedContentStep = SessionStepEntity(
          id: 'mixed_content_step',
          title: 'Mixed Content Step',
          contentItems: mixedContentItems,
          type: SessionStepType.content,
          isCompleted: false,
        );

        expect(mixedContentStep.contentItems.length, 3);
        expect(mixedContentStep.contentItems[0].type, ContentType.text);
        expect(mixedContentStep.contentItems[1].type, ContentType.image);
        expect(mixedContentStep.contentItems[2].type, ContentType.video);
      });
    });
  });
}
