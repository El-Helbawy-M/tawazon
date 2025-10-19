import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session5steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'المقدمة',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content: '''⦁	"أحيانًا مشاعرنا بتخلينا نتصرف بشكل تلقائي."
⦁	"لكن مش دايمًا المشاعر بتكون دقيقة أو مفيدة."
⦁	"الحل؟ نتعلم نعمل العكس!"
''',
      ),
    ],
    type: SessionStepType.introduction,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_2',
    title: 'لاحظ الشعور',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content: """⦁	   اسأل نفسك: "حاسس بإيه دلوقتي؟"
⦁	  سمِّ المشاعر: خوف، غضب، حزن، خجل
""",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_3',
    title: 'افحص دقة الشعور 🔍',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "هل الشعور مناسب؟ لو خطر حقيقي اتبعه، لو مبالغ فيه حضر نفسك للعكس.",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_4',
    title: 'اعمل العكس ⚡',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content: """⦁	الخوف → واجه خطوة صغيرة.
⦁	الحزن → تحرك أو قابل الناس.
⦁	الغضب → اهدأ واتكلم بلطف.
⦁	الخجل → ارفع راسك وابتسم
""",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_5',
    title: 'كرر واستمر 🌱',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content: "زي التمرين الرياضي، مع الوقت جسمك وعقلك هيتعودوا.",
      ),
      ContentItemEntity.image(
        id: 'item_2',
        imageUrl: 'assets/images/session_5_image_1_screen_5.png',
        caption: '',
      ),
    ],
    type: SessionStepType.summary,
    isCompleted: false,
  ),
];
