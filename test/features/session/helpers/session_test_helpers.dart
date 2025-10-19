import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tawazon/features/session/ui/bloc/session_bloc.dart';
import 'package:tawazon/features/session/core/entities/session_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';
import 'package:tawazon/features/session/core/entities/content_item_entity.dart';

/// Mock SessionBloc for testing
class MockSessionBloc extends Mock implements SessionBloc {}

/// Creates a testable shared widget with SessionBloc provider
Widget createSessionTestApp({
  Widget? home,
  SessionBloc? sessionBloc,
}) {
  return MaterialApp(
    home: BlocProvider<SessionBloc>(
      create: (_) => sessionBloc ?? MockSessionBloc(),
      child: home ?? const Scaffold(),
    ),
  );
}

/// Pumps a widget with SessionBloc provider
Future<void> pumpSessionWidget(
  WidgetTester tester,
  Widget widget, {
  SessionBloc? sessionBloc,
}) async {
  await tester.pumpWidget(
    createSessionTestApp(
      home: widget,
      sessionBloc: sessionBloc,
    ),
  );
}

/// Test data class containing common session test data
class SessionTestData {
  /// Sample content items for testing
  static const List<ContentItemEntity> sampleContentItems = [
    ContentItemEntity(
      id: 'text_content_1',
      type: ContentType.text,
      content: 'Sample text content for testing',
    ),
    ContentItemEntity(
      id: 'image_content_1',
      type: ContentType.image,
      content: 'assets/images/test_image.jpg',
      caption: 'Test image caption',
    ),
    ContentItemEntity(
      id: 'video_content_1',
      type: ContentType.video,
      content: 'assets/videos/test_video.mp4',
      caption: 'Test video caption',
      metadata: {'duration': 120},
    ),
  ];

  /// Sample session steps for testing
  static final List<SessionStepEntity> sampleSteps = [
    SessionStepEntity(
      id: 'test_step_1',
      title: 'Introduction Step',
      contentItems: [sampleContentItems[0]],
      type: SessionStepType.introduction,
      isCompleted: false,
      metadata: {'order': 1},
    ),
    SessionStepEntity(
      id: 'test_step_2',
      title: 'Content Step',
      contentItems: [sampleContentItems[1], sampleContentItems[2]],
      type: SessionStepType.content,
      isCompleted: false,
      metadata: {'order': 2, 'difficulty': 'medium'},
    ),
    SessionStepEntity(
      id: 'test_step_3',
      title: 'Summary Step',
      contentItems: [sampleContentItems[0], sampleContentItems[1]],
      type: SessionStepType.summary,
      isCompleted: false,
      metadata: {'order': 3},
    ),
    SessionStepEntity(
      id: 'test_step_4',
      title: 'Conclusion Step',
      contentItems: [sampleContentItems[2]],
      type: SessionStepType.conclusion,
      isCompleted: false,
      metadata: {'order': 4},
    ),
  ];

  /// Basic session entity for testing
  static final SessionEntity basicSessionEntity = SessionEntity(
    id: 'test_session_1',
    title: 'Test Session',
    description: 'A session created for testing purposes',
    steps: sampleSteps,
    currentStep: 0,
    status: EnumSessionStatus.notStarted,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
  );

  /// In-progress session entity for testing
  static final SessionEntity inProgressSessionEntity = SessionEntity(
    id: 'test_session_2',
    title: 'In Progress Test Session',
    description: 'A session that is currently in progress',
    steps: [
      sampleSteps[0].copyWith(isCompleted: true),
      sampleSteps[1].copyWith(isCompleted: true),
      sampleSteps[2],
      sampleSteps[3],
    ],
    currentStep: 2,
    status: EnumSessionStatus.inProgress,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
  );

  /// Completed session entity for testing
  static final SessionEntity completedSessionEntity = SessionEntity(
    id: 'test_session_3',
    title: 'Completed Test Session',
    description: 'A session that has been completed',
    steps: sampleSteps.map((step) => step.copyWith(isCompleted: true)).toList(),
    currentStep: 3,
    status: EnumSessionStatus.completed,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
    completedAt: DateTime(2024, 1, 1, 11, 30, 0),
  );

  /// Single step session entity for testing edge cases
  static final SessionEntity singleStepSessionEntity = SessionEntity(
    id: 'single_step_session',
    title: 'Single Step Session',
    description: 'A session with only one step',
    steps: [sampleSteps.first],
    currentStep: 0,
    status: EnumSessionStatus.notStarted,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
  );

  /// Empty session entity for testing edge cases
  static final SessionEntity emptySessionEntity = SessionEntity(
    id: 'empty_session',
    title: 'Empty Session',
    description: 'A session with no steps',
    steps: const [],
    currentStep: 0,
    status: EnumSessionStatus.notStarted,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
  );

  /// Large session entity with many steps for performance testing
  static final SessionEntity largeSessionEntity = SessionEntity(
    id: 'large_session',
    title: 'Large Session',
    description: 'A session with many steps for performance testing',
    steps: List.generate(
      50,
      (index) => SessionStepEntity(
        id: 'large_step_$index',
        title: 'Step ${index + 1}',
        contentItems: [
          ContentItemEntity(
            id: 'content_${index}_1',
            type: ContentType.text,
            content: 'Content for step ${index + 1}',
          ),
        ],
        type: index % 4 == 0
            ? SessionStepType.introduction
            : index % 4 == 3
                ? SessionStepType.conclusion
                : index % 4 == 2
                    ? SessionStepType.summary
                    : SessionStepType.content,
        isCompleted: index < 25, // First half completed
        metadata: {'order': index + 1},
      ),
    ),
    currentStep: 25,
    status: EnumSessionStatus.inProgress,
    createdAt: DateTime(2024, 1, 1, 10, 0, 0),
  );
}

/// Helper class for creating content items with different configurations
class ContentItemTestFactory {
  /// Creates a text content item with optional title
  static ContentItemEntity createTextContent({
    String id = 'text_content',
    String content = 'Sample text content',
    String? title,
  }) {
    return ContentItemEntity.text(
      id: id,
      content: content,
      title: title,
    );
  }

  /// Creates an image content item with optional caption and alt text
  static ContentItemEntity createImageContent({
    String id = 'image_content',
    String imageUrl = 'assets/images/sample.jpg',
    String? caption,
    String? altText,
  }) {
    return ContentItemEntity.image(
      id: id,
      imageUrl: imageUrl,
      caption: caption,
      altText: altText,
    );
  }

  /// Creates a video content item with optional caption and duration
  static ContentItemEntity createVideoContent({
    String id = 'video_content',
    String videoUrl = 'assets/videos/sample.mp4',
    String? caption,
    int? durationSeconds,
  }) {
    return ContentItemEntity.video(
      id: id,
      videoUrl: videoUrl,
      caption: caption,
      durationSeconds: durationSeconds,
    );
  }

  /// Creates a list of mixed content items for testing
  static List<ContentItemEntity> createMixedContentItems({
    int textCount = 1,
    int imageCount = 1,
    int videoCount = 1,
  }) {
    final items = <ContentItemEntity>[];

    for (int i = 0; i < textCount; i++) {
      items.add(createTextContent(
        id: 'text_$i',
        content: 'Text content $i',
      ));
    }

    for (int i = 0; i < imageCount; i++) {
      items.add(createImageContent(
        id: 'image_$i',
        imageUrl: 'assets/images/image_$i.jpg',
        caption: 'Image $i caption',
      ));
    }

    for (int i = 0; i < videoCount; i++) {
      items.add(createVideoContent(
        id: 'video_$i',
        videoUrl: 'assets/videos/video_$i.mp4',
        caption: 'Video $i caption',
        durationSeconds: (i + 1) * 60,
      ));
    }

    return items;
  }
}

/// Helper class for creating session steps with different configurations
class SessionStepTestFactory {
  /// Creates a session step with specified parameters
  static SessionStepEntity createStep({
    String id = 'test_step',
    String title = 'Test Step',
    List<ContentItemEntity>? contentItems,
    SessionStepType type = SessionStepType.content,
    bool isCompleted = false,
    Map<String, dynamic>? metadata,
  }) {
    return SessionStepEntity(
      id: id,
      title: title,
      contentItems: contentItems ?? [ContentItemTestFactory.createTextContent()],
      type: type,
      isCompleted: isCompleted,
      metadata: metadata,
    );
  }

  /// Creates a list of session steps for testing
  static List<SessionStepEntity> createSteps({
    int count = 3,
    SessionStepType? forceType,
    bool allCompleted = false,
  }) {
    return List.generate(count, (index) {
      SessionStepType stepType;
      if (forceType != null) {
        stepType = forceType;
      } else if (index == 0) {
        stepType = SessionStepType.introduction;
      } else if (index == count - 1) {
        stepType = SessionStepType.conclusion;
      } else {
        stepType = index % 2 == 0 ? SessionStepType.content : SessionStepType.summary;
      }

      return createStep(
        id: 'step_${index + 1}',
        title: 'Step ${index + 1}',
        type: stepType,
        isCompleted: allCompleted || index < count ~/ 2,
        metadata: {'order': index + 1},
      );
    });
  }
}

/// Helper class for creating session entities with different configurations
class SessionEntityTestFactory {
  /// Creates a session entity with specified parameters
  static SessionEntity createSession({
    String id = 'test_session',
    String title = 'Test Session',
    String description = 'Test session description',
    List<SessionStepEntity>? steps,
    int currentStep = 0,
    EnumSessionStatus status = EnumSessionStatus.notStarted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SessionEntity(
      id: id,
      title: title,
      description: description,
      steps: steps ?? SessionStepTestFactory.createSteps(),
      currentStep: currentStep,
      status: status,
      createdAt: createdAt ?? DateTime(2024, 1, 1),
      completedAt: completedAt,
    );
  }

  /// Creates a session with progress at specified step
  static SessionEntity createSessionWithProgress({
    String id = 'progress_session',
    int totalSteps = 5,
    int completedSteps = 2,
  }) {
    final steps = SessionStepTestFactory.createSteps(count: totalSteps);
    final updatedSteps = steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      return step.copyWith(isCompleted: index < completedSteps);
    }).toList();

    return createSession(
      id: id,
      title: 'Session with Progress',
      steps: updatedSteps,
      currentStep: completedSteps,
      status: completedSteps == 0
          ? EnumSessionStatus.notStarted
          : completedSteps == totalSteps
              ? EnumSessionStatus.completed
              : EnumSessionStatus.inProgress,
      completedAt: completedSteps == totalSteps ? DateTime(2024, 1, 2) : null,
    );
  }
}

/// Common test expectations and assertions
class SessionTestExpectations {
  /// Verifies that a session entity has the expected basic properties
  static void expectValidSessionEntity(SessionEntity session) {
    expect(session.id, isNotEmpty);
    expect(session.title, isNotEmpty);
    expect(session.description, isNotEmpty);
    expect(session.steps, isNotEmpty);
    expect(session.currentStep, greaterThanOrEqualTo(0));
    expect(session.createdAt, isA<DateTime>());
  }

  /// Verifies that a session step has the expected basic properties
  static void expectValidSessionStep(SessionStepEntity step) {
    expect(step.id, isNotEmpty);
    expect(step.title, isNotEmpty);
    expect(step.contentItems, isNotNull);
    expect(step.type, isA<SessionStepType>());
    expect(step.isCompleted, isA<bool>());
  }

  /// Verifies that a content item has the expected basic properties
  static void expectValidContentItem(ContentItemEntity item) {
    expect(item.id, isNotEmpty);
    expect(item.type, isA<ContentType>());
    expect(item.content, isNotEmpty);
  }

  /// Verifies session progress calculations
  static void expectCorrectProgress(SessionEntity session) {
    if (session.steps.isEmpty) {
      expect(session.progress, 0.0);
    } else {
      final expectedProgress = (session.currentStep + 1) / session.steps.length;
      expect(session.progress, closeTo(expectedProgress, 0.001));
    }
  }

  /// Verifies session navigation capabilities
  static void expectCorrectNavigationCapabilities(SessionEntity session) {
    expect(session.canGoNext, session.currentStep < session.steps.length - 1);
    expect(session.canGoPrevious, session.currentStep > 0);
  }

  /// Verifies session completion status
  static void expectCorrectCompletionStatus(SessionEntity session) {
    expect(session.isCompleted, session.status == EnumSessionStatus.completed);
  }
}

/// Utility functions for test setup and teardown
class SessionTestUtils {
  /// Waits for async operations to complete in tests
  static Future<void> waitForAsync([int milliseconds = 10]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Creates a matcher for session loaded state
  static Matcher isSessionLoadedState() {
    return predicate<dynamic>((state) {
      return state.runtimeType.toString() == '_SessionLoadedState';
    }, 'is SessionLoadedState');
  }

  /// Extracts session from a session loaded state
  static SessionEntity? extractSessionFromState(dynamic state) {
    if (state.runtimeType.toString() == '_SessionLoadedState') {
      try {
        return (state as dynamic).session as SessionEntity;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Generates unique IDs for test entities
  static String generateTestId([String prefix = 'test']) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Creates a deep copy of a list of steps for testing immutability
  static List<SessionStepEntity> copyStepsList(List<SessionStepEntity> steps) {
    return steps.map((step) => step.copyWith()).toList();
  }
}
