import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session3steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'العقل',
    contentItems: [
      ContentItemEntity.text(
        id: 'status_1',
        content: '''⦁	الحالة اللي بيكون فيها السلوك مسيطر عليه بالكامل بالمشاعر.
⦁	الأفكار والقرارات مبنية على الانفعالات (غضب، خوف، حزن، فرح).
⦁	ممكن يؤدي إلى اندفاع أو تصرفات غير عقلانية.''',
        title: "العقل العاطفي (Emotion Mind)",
      ),
      ContentItemEntity.text(
        id: 'status_2',
        content: '''⦁	الحالة اللي بيسيطر فيها المنطق والعقل والتحليل.
⦁	الاعتماد على الحقائق، البيانات، والخبرة السابقة فقط.
⦁	أحيانًا بيهمل العاطفة تمامًا، وبالتالي يقلل من المرونة الإنسانية.''',
        title: 'العقل العقلاني/المنطقي (Reasonable Mind)',
      ),
      ContentItemEntity.text(
        id: 'status_3',
        content: '''⦁	الحالة المتوازنة بين العقل العاطفي والعقل العقلاني.
⦁	القدرة على الاستماع للمشاعر والعقل معًا، واتخاذ قرار حكيم.
⦁	يُعتبر الحالة المثالية ''',
        title: 'العقل الحكيم (Wise Mind)',
      ),
    ],
    type: SessionStepType.introduction,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_2',
    title: 'العقل الحكيم',
    contentItems: [
      ContentItemEntity.image(
        id: 'image',
        imageUrl: 'assets/images/session_3_image_1_screen_2.png',
        caption: '',
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_3',
    title: 'تمرين',
    contentItems: [
      ContentItemEntity.singleSelect(
        id: 'select option',
        label: "على مدار الساعات القليلة الماضيه....ماهى اكثر حالة للعقل كانت مستحوذه عليك؟",
        options: [
          {
            'value': 'العقل العاطفي',
            'label': 'العقل العاطفي',
          },
          {
            'value': 'العقل العقلاني',
            'label': 'العقل العقلاني',
          },
          {
            'value': 'العقل الحكيم',
            'label': 'العقل الحكيم',
          },
        ],
        required: true,
      ),
    ],
    type: SessionStepType.quiz,
    isCompleted: false,
  ),
];
