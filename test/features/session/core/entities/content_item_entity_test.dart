import 'package:flutter_test/flutter_test.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';

void main() {
  group('ContentItemEntity', () {
    group('constructor', () {
      test('should create a valid ContentItemEntity with required parameters', () {
        const contentItem = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample text content',
        );

        expect(contentItem.id, 'content_1');
        expect(contentItem.type, ContentType.text);
        expect(contentItem.content, 'Sample text content');
        expect(contentItem.caption, isNull);
        expect(contentItem.metadata, isNull);
      });

      test('should create ContentItemEntity with optional parameters', () {
        const contentItem = ContentItemEntity(
          id: 'content_2',
          type: ContentType.image,
          content: 'assets/images/sample.jpg',
          caption: 'Sample image caption',
          metadata: {'altText': 'Alternative text', 'size': '1920x1080'},
        );

        expect(contentItem.caption, 'Sample image caption');
        expect(contentItem.metadata, {'altText': 'Alternative text', 'size': '1920x1080'});
      });
    });

    group('factory constructors', () {
      group('ContentItemEntity.text', () {
        test('should create text content item with basic parameters', () {
          final textItem = ContentItemEntity.text(
            id: 'text_1',
            content: 'This is text content',
          );

          expect(textItem.id, 'text_1');
          expect(textItem.type, ContentType.text);
          expect(textItem.content, 'This is text content');
          expect(textItem.caption, isNull);
          expect(textItem.metadata, isNull);
        });

        test('should create text content item with title in metadata', () {
          final textItem = ContentItemEntity.text(
            id: 'text_2',
            content: 'This is text content with title',
            title: 'Content Title',
          );

          expect(textItem.metadata, {'title': 'Content Title'});
        });

        test('should create text content item without title when null', () {
          final textItem = ContentItemEntity.text(
            id: 'text_3',
            content: 'This is text content without title',
            title: null,
          );

          expect(textItem.metadata, isNull);
        });
      });

      group('ContentItemEntity.image', () {
        test('should create image content item with basic parameters', () {
          final imageItem = ContentItemEntity.image(
            id: 'image_1',
            imageUrl: 'assets/images/sample.jpg',
          );

          expect(imageItem.id, 'image_1');
          expect(imageItem.type, ContentType.image);
          expect(imageItem.content, 'assets/images/sample.jpg');
          expect(imageItem.caption, isNull);
          expect(imageItem.metadata, isNull);
        });

        test('should create image content item with caption', () {
          final imageItem = ContentItemEntity.image(
            id: 'image_2',
            imageUrl: 'assets/images/sample.jpg',
            caption: 'Beautiful landscape',
          );

          expect(imageItem.caption, 'Beautiful landscape');
        });

        test('should create image content item with altText in metadata', () {
          final imageItem = ContentItemEntity.image(
            id: 'image_3',
            imageUrl: 'assets/images/sample.jpg',
            altText: 'Alternative text for accessibility',
          );

          expect(imageItem.metadata, {'altText': 'Alternative text for accessibility'});
        });

        test('should create image content item with both caption and altText', () {
          final imageItem = ContentItemEntity.image(
            id: 'image_4',
            imageUrl: 'assets/images/sample.jpg',
            caption: 'Beautiful landscape',
            altText: 'Mountain view with sunset',
          );

          expect(imageItem.caption, 'Beautiful landscape');
          expect(imageItem.metadata, {'altText': 'Mountain view with sunset'});
        });

        test('should create image content item without altText when null', () {
          final imageItem = ContentItemEntity.image(
            id: 'image_5',
            imageUrl: 'assets/images/sample.jpg',
            altText: null,
          );

          expect(imageItem.metadata, isNull);
        });
      });

      group('ContentItemEntity.video', () {
        test('should create video content item with basic parameters', () {
          final videoItem = ContentItemEntity.video(
            id: 'video_1',
            videoUrl: 'assets/videos/sample.mp4',
          );

          expect(videoItem.id, 'video_1');
          expect(videoItem.type, ContentType.video);
          expect(videoItem.content, 'assets/videos/sample.mp4');
          expect(videoItem.caption, isNull);
          expect(videoItem.metadata, isNull);
        });

        test('should create video content item with caption', () {
          final videoItem = ContentItemEntity.video(
            id: 'video_2',
            videoUrl: 'assets/videos/sample.mp4',
            caption: 'Educational video about emotions',
          );

          expect(videoItem.caption, 'Educational video about emotions');
        });

        test('should create video content item with duration in metadata', () {
          final videoItem = ContentItemEntity.video(
            id: 'video_3',
            videoUrl: 'assets/videos/sample.mp4',
            durationSeconds: 300,
          );

          expect(videoItem.metadata, {'duration': 300});
        });

        test('should create video content item with both caption and duration', () {
          final videoItem = ContentItemEntity.video(
            id: 'video_4',
            videoUrl: 'assets/videos/sample.mp4',
            caption: 'Training session video',
            durationSeconds: 600,
          );

          expect(videoItem.caption, 'Training session video');
          expect(videoItem.metadata, {'duration': 600});
        });

        test('should create video content item without duration when null', () {
          final videoItem = ContentItemEntity.video(
            id: 'video_5',
            videoUrl: 'assets/videos/sample.mp4',
            durationSeconds: null,
          );

          expect(videoItem.metadata, isNull);
        });
      });
    });

    group('ContentType enum', () {
      test('should have all expected values', () {
        expect(ContentType.values, contains(ContentType.text));
        expect(ContentType.values, contains(ContentType.image));
        expect(ContentType.values, contains(ContentType.video));
      });

      test('should have correct number of enum values', () {
        expect(ContentType.values.length, 3);
      });
    });

    group('equality and props', () {
      test('should be equal when all properties are the same', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
          caption: 'Sample caption',
          metadata: {'key': 'value'},
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
          caption: 'Sample caption',
          metadata: {'key': 'value'},
        );

        expect(contentItem1, equals(contentItem2));
        expect(contentItem1.hashCode, equals(contentItem2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_2',
          type: ContentType.text,
          content: 'Sample content',
        );

        expect(contentItem1, isNot(equals(contentItem2)));
      });

      test('should not be equal when type differs', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.image,
          content: 'Sample content',
        );

        expect(contentItem1, isNot(equals(contentItem2)));
      });

      test('should not be equal when content differs', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content 1',
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content 2',
        );

        expect(contentItem1, isNot(equals(contentItem2)));
      });

      test('should not be equal when caption differs', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.image,
          content: 'image.jpg',
          caption: 'Caption 1',
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.image,
          content: 'image.jpg',
          caption: 'Caption 2',
        );

        expect(contentItem1, isNot(equals(contentItem2)));
      });

      test('should not be equal when metadata differs', () {
        const contentItem1 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
          metadata: {'key': 'value1'},
        );

        const contentItem2 = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
          metadata: {'key': 'value2'},
        );

        expect(contentItem1, isNot(equals(contentItem2)));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        const contentItem = ContentItemEntity(
          id: 'content_1',
          type: ContentType.text,
          content: 'Sample content',
          caption: 'Sample caption',
          metadata: {'key': 'value'},
        );

        final stringRepresentation = contentItem.toString();

        expect(stringRepresentation, contains('ContentItemEntity'));
        expect(stringRepresentation, contains('id: content_1'));
        expect(stringRepresentation, contains('type: ContentType.text'));
        expect(stringRepresentation, contains('content: Sample content'));
        expect(stringRepresentation, contains('caption: Sample caption'));
        expect(stringRepresentation, contains('metadata: {key: value}'));
      });

      test('should handle null values in toString', () {
        const contentItem = ContentItemEntity(
          id: 'content_1',
          type: ContentType.image,
          content: 'image.jpg',
        );

        final stringRepresentation = contentItem.toString();

        expect(stringRepresentation, contains('caption: null'));
        expect(stringRepresentation, contains('metadata: null'));
      });
    });

    group('edge cases', () {
      test('should handle empty strings', () {
        const contentItem = ContentItemEntity(
          id: '',
          type: ContentType.text,
          content: '',
          caption: '',
        );

        expect(contentItem.id, '');
        expect(contentItem.content, '');
        expect(contentItem.caption, '');
      });

      test('should handle very long content', () {
        final longContent = 'A' * 10000;
        final contentItem = ContentItemEntity(
          id: 'long_content',
          type: ContentType.text,
          content: longContent,
        );

        expect(contentItem.content.length, 10000);
        expect(contentItem.content, longContent);
      });

      test('should handle complex metadata', () {
        const complexMetadata = {
          'nested': {'key': 'value'},
          'list': [1, 2, 3],
          'boolean': true,
          'number': 42.5,
        };

        const contentItem = ContentItemEntity(
          id: 'complex_metadata',
          type: ContentType.video,
          content: 'video.mp4',
          metadata: complexMetadata,
        );

        expect(contentItem.metadata, complexMetadata);
      });
    });
  });
}
