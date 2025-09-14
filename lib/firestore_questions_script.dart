import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> runUploadScript() async {
  final firestore = FirebaseFirestore.instance;

  await uploadSurvey(
    firestore: firestore,
    questionnaireId: 'depression',
    surveyData: {
      'title': 'مقياس بيك للاكتئاب',
      'description': 'استبيان مختصر لتقييم الاكتئاب خلال الأسبوعين الماضيين.',
      'language': 'ar',
      'version': 1,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    questions: depressionQuestions,
  );

  await uploadSurvey(
    firestore: firestore,
    questionnaireId: 'anxiety',
    surveyData: {
      'title': 'مقياس القلق',
      'description': 'استبيان مختصر لتقييم أعراض القلق خلال الأسبوعين الماضيين.',
      'language': 'ar',
      'version': 1,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    },
    questions: anxietyQuestions,
  );

  print('✔ All surveys and questions uploaded.');
}

Future<void> uploadSurvey({
  required FirebaseFirestore firestore,
  required String questionnaireId,
  required Map<String, dynamic> surveyData,
  required List<Map<String, dynamic>> questions,
}) async {
  final surveyRef = firestore.collection('questionnaires').doc(questionnaireId);
  await surveyRef.set(surveyData); // Create the survey document

  final batch = firestore.batch();
  final questionsRef = surveyRef.collection('questions');

  for (var question in questions) {
    final docRef = questionsRef.doc(question['id']);
    batch.set(docRef, question);
  }

  await batch.commit();
}


// Depression questions
final List<Map<String, dynamic>> depressionQuestions = [
  {
    "order": 1,
    "id": "sadness",
    "type": "single_choice",
    "text": "الحزن",
    "options": [
      "لا أشعر بالحزن.",
      "أشعر بالحزن أحيانًا.",
      "أشعر بالحزن معظم الوقت.",
      "أشعر بالحزن طوال الوقت ولا أقدر التغلب عليه."
    ]
  },
  {
    "order": 2,
    "id": "pessimism",
    "type": "single_choice",
    "text": "التشاؤم",
    "options": [
      "لا أشعر بالتشاؤم حول المستقبل.",
      "أشعر ببعض التشاؤم.",
      "أرى أن لا أمل في المستقبل.",
      "مقتنع أن لا شيء سيتحسن أبدًا."
    ]
  },
  {
    "order": 3,
    "id": "failure",
    "type": "single_choice",
    "text": "الفشل",
    "options": [
      "لا أشعر أني فاشل.",
      "أشعر أني أخفقت أكثر من الآخرين.",
      "أشعر أن حياتي كلها سلسلة من الفشل.",
      "أشعر أني فاشل تمامًا."
    ]
  },
  {
    "order": 4,
    "id": "loss_of_pleasure",
    "type": "single_choice",
    "text": "فقدان المتعة",
    "options": [
      "أستمتع بالأشياء كالمعتاد.",
      "لا أتمتع بالأشياء كما في السابق.",
      "أتمتع بقليل من الأشياء.",
      "لا أتمتع بأي شيء على الإطلاق."
    ]
  },
  {
    "order": 5,
    "id": "guilt",
    "type": "single_choice",
    "text": "الشعور بالذنب",
    "options": [
      "لا أشعر بالذنب.",
      "أشعر بالذنب أحيانًا.",
      "أشعر بالذنب معظم الوقت.",
      "أشعر بالذنب طوال الوقت."
    ]
  },
  {
    "order": 6,
    "id": "self_worth",
    "type": "single_choice",
    "text": "تقدير الذات",
    "options": [
      "لا أشعر أني سيئ.",
      "أنتقد نفسي أكثر من اللازم.",
      "أشعر أني عديم القيمة.",
      "أكره نفسي تمامًا."
    ]
  },
  {
    "order": 7,
    "id": "decision_making",
    "type": "single_choice",
    "text": "صعوبة اتخاذ القرار",
    "options": [
      "أتخذ القرارات بسهولة.",
      "أؤجل القرارات أحيانًا.",
      "أجد صعوبة كبيرة في اتخاذ القرارات.",
      "لا أستطيع اتخاذ أي قرار."
    ]
  },
  {
    "order": 8,
    "id": "fatigue",
    "type": "single_choice",
    "text": "التعب",
    "options": [
      "لا أشعر بالتعب أكثر من المعتاد.",
      "أتعب بسرعة أكبر من السابق.",
      "أشعر بالتعب معظم الوقت.",
      "أشعر بالإرهاق التام."
    ]
  },
  {
    "order": 9,
    "id": "sleep",
    "type": "single_choice",
    "text": "النوم",
    "options": [
      "أنام جيدًا كالمعتاد.",
      "أنام أقل من المعتاد.",
      "أستيقظ عدة مرات ليلًا.",
      "لا أستطيع النوم تقريبًا."
    ]
  },
  {
    "order": 10,
    "id": "suicidal_thoughts",
    "type": "single_choice",
    "text": "الأفكار الانتحارية",
    "options": [
      "لا أفكر في الانتحار.",
      "تراودني فكرة الانتحار أحيانًا، دون نية فعلية.",
      "أرغب في الانتحار.",
      "سأحاول الانتحار إذا أتيحت لي الفرصة."
    ]
  }
];

// Anxiety questions
final List<Map<String, dynamic>> anxietyQuestions = [
  {
    "order": 1,
    "id": "tension",
    "type": "single_choice",
    "text": "أشعر بالتوتر أو العصبية.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 2,
    "id": "fear",
    "type": "single_choice",
    "text": "أشعر بالخوف من حدوث شيء سيئ.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 3,
    "id": "concentration",
    "type": "single_choice",
    "text": "يصعب عليّ التركيز بسبب القلق.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 4,
    "id": "relaxing_difficulty",
    "type": "single_choice",
    "text": "أشعر بعدم القدرة على الاسترخاء.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 5,
    "id": "heartbeat",
    "type": "single_choice",
    "text": "أشعر بخفقان القلب أو تسارع ضرباته.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 6,
    "id": "trembling",
    "type": "single_choice",
    "text": "أشعر برجفة أو ارتعاش.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 7,
    "id": "breathing",
    "type": "single_choice",
    "text": "أشعر بضيق التنفس أو صعوبة في التنفس.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 8,
    "id": "dizziness",
    "type": "single_choice",
    "text": "أشعر بالدوار أو عدم الاتزان.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 9,
    "id": "stomach",
    "type": "single_choice",
    "text": "أشعر بعدم الارتياح في المعدة أو بالغثيان.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  },
  {
    "order": 10,
    "id": "panic",
    "type": "single_choice",
    "text": "أشعر بخوف مفاجئ أو نوبات هلع.",
    "options": ["أبداً", "أحياناً", "كثيراً", "دائماً"]
  }
];
