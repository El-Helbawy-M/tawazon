import 'package:tawazon/features/session/core/entities/content_item_entity.dart';
import 'package:tawazon/features/session/core/entities/session_step_entity.dart';

final session4steps = [
  SessionStepEntity(
    id: 'step_1',
    title: 'المهارة الأولى لتقليل الحساسية للعقل العاطفي',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        title: "الفكرة الأساسية",
        content:
            '''عندما يعتاد الإنسان على تجربة مشاعر إيجابية بشكل منتظم، يصبح أقل عرضة لسيطرة العقل العاطفي عليه في المواقف الضاغطة. هذه المهارة تقوم على إدخال المتعة والرضا تدريجيًا في الحياة اليومية حتى تصبح جزءًا من الروتين.''',
      ),
      ContentItemEntity.text(
        id: 'item_2',
        title: 'الخطوات العملية',
        content: '''⦁	خصص وقتًا يوميًا لأشياء صغيرة تجلب لك السرور
⦁	سماع موسيقى مفضلة
⦁	قضاء وقت مع شخص تحبه
⦁	تناول وجبة لذيذة
⦁	المشي في مكان مفضل
''',
      ),
      ContentItemEntity.image(
        id: 'item_3',
        imageUrl: 'assets/images/session_4_image_1_screen_1.png',
        caption: '',
      ),
    ],
    type: SessionStepType.introduction,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_2',
    title: 'العقل الحكيم',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        title: "بناء حياة مليئة بالمعنى على المدى الطويل",
        content:
            """⦁	ضع أهدافًا تتماشى مع قيمك العميقة (مثل: التعليم، العطاء، الإبداع).
⦁	اتخذ خطوات صغيرة نحو هذه الأهداف يومًا بعد يوم.
⦁	تذكّر أن تراكم التجارب الإيجابية الصغيرة يقود لشعور بالرضا والاستقرار.
⦁	المهارة الأولى لتقليل الحساسية للعقل العاطفي: جمع ومراكمة المشاعر الإيجابية
""",
      ),
      ContentItemEntity.image(
        id: "item_2",
        imageUrl: "assets/images/session_4_image_2_screen_2.png",
        caption: "",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_3',
    title: 'تمرين',
    contentItems: [
      ContentItemEntity.text(
        id: 'item_1',
        title: "تسجيل قائمة بالأنشطة الإيجابية",
        content: """⦁	دوّن 10–15 نشاطًا يسعدك مهما كان بسيطًا.
⦁	وزّعها على أسبوعك.
⦁	كل يوم، اختر نشاطًا واحدًا على الأقل لتقوم به""",
      ),
    ],
    type: SessionStepType.content,
    isCompleted: false,
  ),
  SessionStepEntity(
    id: 'step_4',
    title: 'تمرين',
    contentItems: [
      ContentItemEntity.inputLongText(
        id: 'item_1',
        label:
            "راجع الثلاث خطوات المذكورة في مهارات تقليل الحساسية للعقل العاطفى واكتب في السطور التالية الأنشطة والاهداف التي قمت باختيارها",
        minLines: 2,
        maxLines: 10,
        required: true,
      ),
    ],
    type: SessionStepType.quiz,
    isCompleted: false,
  ),
];
