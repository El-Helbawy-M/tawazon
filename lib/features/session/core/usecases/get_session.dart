import 'package:dartz/dartz.dart';
import '../entities/session_entity.dart';
import '../entities/session_step_entity.dart';
import '../entities/content_item_entity.dart';
import '../entities/session_status.dart';
import '../../../../config/app_errors.dart';

/// Use case for retrieving a session by ID with hardcoded data
class GetSession {
  const GetSession();

  /// Executes the use case to get a session
  ///
  /// [sessionId] The ID of the session to retrieve
  ///
  /// Returns [Either<Failure, SessionEntity>] containing the session data
  /// or a failure if the operation fails
  Future<Either<Failure, SessionEntity>> call(String sessionId, int completedScreenCount) async {
    if (sessionId.isEmpty) {
      return Left(ValidationFailure("Session ID cannot be empty"));
    }

    try {
      // Return hardcoded session data
      final session = _createHardcodedSession(sessionId);
      final updatedSession = _updateStepsCompletion(session.steps, completedScreenCount);
      SessionEntity finalSession = session.copyWith(steps: updatedSession, currentStep: completedScreenCount);
      return Right(finalSession);
    } catch (e) {
      return Left(UnknownFailure('Failed to retrieve session'));
    }
  }

  /// Updates the completion status of steps based on the number of completed screens
  /// 
  /// [steps] The list of session steps to update
  /// [completedScreenCount] The number of screens that have been completed
  /// 
  /// Returns a new list of steps with updated completion status
  List<SessionStepEntity> _updateStepsCompletion(List<SessionStepEntity> steps, int completedScreenCount) {
    final updatedSteps = <SessionStepEntity>[];
    
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isCompleted = i < completedScreenCount;
      
      updatedSteps.add(step.copyWith(isCompleted: isCompleted));
    }
    
    return updatedSteps;
  }

  /// Creates a hardcoded session with 7 steps, later will be updated to fetch step by session id,
  /// but still the steps will be hard coded
  SessionEntity _createHardcodedSession(String sessionId) {
    final steps = [
      SessionStepEntity(
        id: 'step_1',
        title: 'ما هي المشاعر؟ ',
        contentItems: [
          ContentItemEntity.text(
            id: 'emotions_definition_text',
            content:
                '''المشاعر هي استجابات داخلية طبيعية يمر بها الإنسان عند مواجهة مواقف أو أحداث معينة، وتعبر عن حالته النفسية في تلك اللحظة. 
قد تكون المشاعر إيجابية مثل الفرح والرضا، أو سلبية مثل الحزن والخوف، وهي تساعد الإنسان على فهم نفسه والتواصل مع الآخرين ''',
          ),
        ],
        type: SessionStepType.introduction,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_2',
        title: 'المشاعر',
        contentItems: [
          ContentItemEntity.image(
            id: 'content_image_1',
            imageUrl: 'assets/images/session_1_image_1_screen_2.jpg',
            caption: 'مثال توضيحي للمفاهيم الأساسية',
          ),
        ],
        type: SessionStepType.content,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_3',
        title: 'وظيفة المشاعر ',
        contentItems: [
          ContentItemEntity.text(
            id: 'emotions_function_explanation_text',
            content:
                '''الجميع يشعر بالغضب أو القلق، لكن المشكلة ليست فيما تشعر به. المشكلة في تنظيم وإدارة ما تشعر به". 
عندما تفهم مشاعرك، يمكنك: 
⦁	تخفيف القلق بمعرفة مصدره. 
⦁	تحسين علاقاتك بالتعبير عنها بذكاء. 
⦁	اتخاذ قرارات أفضل دون أن تُحكَم بمشاعر مؤقتة. 
 
''',
          ),
        ],
        type: SessionStepType.content,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_4',
        title: 'معنى إدارة المشاعر',
        contentItems: [
          ContentItemEntity.text(
            id: 'conclusion_text_1',
            content:
                '''إدارة المشاعر هي القدرة على التعرف على مشاعرك وفهمها والتحكم في طريقة التعبير عنها بشكل مناسب، بحيث لا تؤثر سلبًا على نفسك أو على من حولك.
وتشمل أيضًا القدرة على التعامل مع مشاعر الآخرين والتصرف بحكمة في المواقف المختلفة.''',
          ),
          ContentItemEntity.image(
            id: 'emotion_management_visual_image',
            imageUrl: 'assets/images/session_1_image_2_screen_4.png',
          ),
        ],
        type: SessionStepType.content,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_5',
        title: 'الهدف الأساسي من تنظيم المشاعر',
        contentItems: [
          ContentItemEntity.text(
            id: 'emotion_regulation_goals_text',
            content: '''⦁	التخلص من المعاناة النفسية وليس التخلص من المشاعر لان المشاعر الصعبة او المزعجة يحمل داخله رغبات فمثلا شعور الخوف قد يحمل رغبه في الهرب.
⦁	فهم المشاعر يحسن من التواصل مع الاخرين''',
          ),
          ContentItemEntity.image(
            id: 'emotion_regulation_goals_image',
            imageUrl: 'assets/images/session_1_image_3_screen_5.jpg',
          ),
        ],
        type: SessionStepType.content,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_6',
        title: 'المشاعر والجسد ',
        contentItems: [
          ContentItemEntity.text(
            id: 'conclusion_text_1',
            content:
                '''المشاعر والجسد مرتبطان ارتباطًا وثيقًا؛ فكل ما نشعر به ينعكس بشكل مباشر على أجسامنا 
            .فعلى سبيل المثال، عندما نشعر بالخوف يتسارع نبض القلب ويتعرق الجسم، وعندما نشعر بالفرح يزداد نشاطنا وتتحسن طاقتنا. كذلك قد يؤدي الحزن أو القلق المستمر إلى آلام جسدية مثل الصداع أو اضطرابات النوم. لذلك فإن فهم العلاقة بين المشاعر والجسد يساعدنا على إدراك أهمية الاهتمام بصحتنا النفسية والجسدية معًا لتحقيق التوازن والراحة.''',
          ),
          ContentItemEntity.image(
            id: 'content_image_1',
            imageUrl: 'assets/images/session_1_image_4_screen_6.jpg',
          ),
        ],
        type: SessionStepType.content,
        isCompleted: false,
      ),
      SessionStepEntity(
        id: 'step_7',
        title: 'كيف تشعر اليوم؟',
        contentItems: [
          ContentItemEntity.image(
            id: 'content_image_1',
            imageUrl: 'assets/images/session_1_image_5_screen_7.jpg',
          ),
          ContentItemEntity.text(
            id: 'conclusion_text_1',
            content: '''عزيزى الطالب: 
على مدى الساعات القليله الماضيه.....ما هو الشعور الغالب عليك؟
انظر الى عجلة المشاعر التاليه واختار منها شعور مناسب؟
عندما تفكر في هذا الشعور ...بماذا تعشر في جسدك (خفة.....ثقل....اختناق....ضربات قلب سريعه....رعشة يدين....جسد مرتاح)
''',
          ),
        ],
        type: SessionStepType.conclusion,
        isCompleted: false,
      ),
    ];

    return SessionEntity(
      id: sessionId,
      title: 'الجلسة التدريبية الأولى',
      description:
          'جلسة تدريبية تفاعلية تحتوي على 7 خطوات متنوعة للتعلم والتطبيق',
      steps: steps,
      currentStep: 0,
      status: EnumSessionStatus.notStarted,
      createdAt: DateTime.now(),
    );
  }
}
