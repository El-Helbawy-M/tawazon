import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session1steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'ما هي المشاعر؟ ',
    contentItems: [
      ContentItemEntity.text(
        id: 'emotions_definition_text',
        content: '''المشاعر هي استجابات داخلية طبيعية يمر بها الإنسان عند مواجهة مواقف أو أحداث معينة، وتعبر عن حالته النفسية في تلك اللحظة. 
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
        content: '''الجميع يشعر بالغضب أو القلق، لكن المشكلة ليست فيما تشعر به. المشكلة في تنظيم وإدارة ما تشعر به". 
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
        content: '''إدارة المشاعر هي القدرة على التعرف على مشاعرك وفهمها والتحكم في طريقة التعبير عنها بشكل مناسب، بحيث لا تؤثر سلبًا على نفسك أو على من حولك.
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
        content: '''المشاعر والجسد مرتبطان ارتباطًا وثيقًا؛ فكل ما نشعر به ينعكس بشكل مباشر على أجسامنا 
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
      ContentItemEntity.image(
        id: 'content_image_2',
        imageUrl: 'assets/images/session_1_image_6_screen_7.jpg',
      ),
    ],
    type: SessionStepType.conclusion,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_8',
    title: 'ما هو الشعور الغالب عليك؟ ',
    contentItems: [
      ContentItemEntity.image(
        id: 'content_image_1',
        imageUrl: 'assets/images/session_1_image_5_screen_7.jpg',
      ),
      ContentItemEntity.inputLongText(
        id: "item_2",
        label: "عندما تفكر في هذا الشعور ...بماذا تعشر في جسدك (خفة.....ثقل....اختناق....ضربات قلب سريعه....رعشة يدين....جسد مرتاح)",
        minLines: 2,
        maxLines: 10,
        required: true,
      ),
    ],
    type: SessionStepType.quiz,
    isCompleted: false,
  ),
];
