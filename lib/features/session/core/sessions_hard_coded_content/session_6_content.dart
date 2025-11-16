import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session6steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'المقدمة',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "المشاعر الصعبة ممكن تغمرنا وتخلينا نحس إننا مش قادرين نستحمل. مهارات تحمل الضيق بتساعدنا نعبر الأزمة من غير ما نؤذي نفسنا.",
      ),
    ],
    type: SessionStepType.introduction,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_2',
    title: 'مهارة التهدئة بالحواس (Self-soothe) 👂👃👀',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "استخدم حواسك الخمسة لتهدئة نفسك: اسمع موسيقى، شم رائحة تحبها، المس شيء ناعم، انظر لشيء جميل، تذوق مشروب دافئ.",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_3',
    title: 'مهارة التشتت (Distract) 🔄',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "حوّل انتباهك عن الشعور القوي: مارس رياضة، اتفرج على فيلم، ساعد غيرك، اكتب أو ارسم.",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_4',
    title: 'مهارة تحسين اللحظة (IMPROVE the moment) 🌸',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "حوّل اللحظة الصعبة للحظة ألطف: استرخِ، تخيّل مكان مريح، صلِّ أو مارس التأمل، كرر كلمات إيجابية.",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_5',
    title: 'مهارة القبول الجذري (Radical Acceptance) 👐',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "اقبل الواقع كما هو بدل ما تقاومه. القبول مش معناه الموافقة، لكنه يخفف الألم.",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_6',
    title: '(مهارة تغيير الاستجابات الجسدية) 💧🏃‍♀️',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        content:
            "برّد جسمك (ماء بارد)، مارس تمرين تنفس، أو جري سريع. تغيير الجسم يغيّر العاطفة.",
      ),
    ],
    type: SessionStepType.summary,
    isCompleted: false,
  ),
];
