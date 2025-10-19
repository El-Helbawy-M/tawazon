import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session2steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'ادارة المشاعر',
    contentItems: [
      ContentItemEntity.text(
        id: 'emotions_managmenet_text',
        content:
            '''عشان نفهم ازاى ندير مشاعرنا ونتعامل معاها, محتاجين نعرف بعض الخرافات عن المشاعر وايه المعلومات الصح الخاصة بالخرافات دى....من فضلك راجع الصورة القادمه وفكر ايه من الخرافات دى انت كنت مصدقه؟''',
      ),
      ContentItemEntity.image(
        id: 'content_image_1',
        imageUrl: 'assets/images/session_2_image_1_screen_1.png',
        caption: '',
      ),
    ],
    type: SessionStepType.introduction,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_2',
    title: 'استبيان',
    contentItems: [
      ContentItemEntity.inputText(
        id: 'user_opinion',
        hint: "اكتب هنا...",
        required: true,
        label:
            "بعد قراءة الجدول السابق....ماهى الخرافات التي كانت لديك عن المشاعر؟",
      ),
    ],
    type: SessionStepType.quiz,
    isCompleted: false,
  ),
];
