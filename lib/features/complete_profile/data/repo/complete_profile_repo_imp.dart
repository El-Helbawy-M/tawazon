import 'dart:developer';

import 'package:base/config/app_errors.dart';
import 'package:base/features/complete_profile/core/models/survey_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

import '../../core/models/complete_profile_submission_params.dart';
import '../../core/models/survey_question.dart';
import '../../core/models/surveys_submission_params.dart';
import '../../core/repo/complete_profile_repo_interface.dart';

class CompleteProfileRepoImp extends CompleteProfileRepoInterface {
  final _firestore = FirebaseFirestore.instance;

  bool _isValidSurveyHeader(Map<String, dynamic> data) {
    return data['title'] != null && data['description'] != null && data['language'] != null && data['version'] != null;
  }

  bool _hasQuestions(QuerySnapshot<Map<String, dynamic>> questionsSnapshot) {
    return questionsSnapshot.docs.isNotEmpty;
  }

  @override
  Future<Either<Failure, List<SurveyForm>>> getSurveyForms() async {
    final List<SurveyForm> surveys = [];

    try {
      final snapshot = await _firestore.collection('questionnaires').where('isActive', isEqualTo: true).get();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        // ⛔️ Skip if header data is invalid
        if (!_isValidSurveyHeader(data)) continue;

        final questionsSnapshot = await _firestore.collection('questionnaires').doc(doc.id).collection('questions').orderBy('order').get();

        // ⛔️ Skip if form has no questions
        if (!_hasQuestions(questionsSnapshot)) continue;

        final questions = questionsSnapshot.docs.map((q) => SurveyQuestion.fromFirebaseDoc(q)).toList();

        surveys.add(SurveyForm(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          language: data['language'],
          version: data['version'],
          questions: questions,
        ));
      }
      return Right(surveys);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? ''));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  //======================================================================
  //======================================================================
  //======================================================================


  Future<void> _submitSurveys(SurveysSubmissionParams params) async{
    Map<String,Map<String,dynamic>> data = {};
    // Iterate over each form and its associated questions
    for (final entry in params.answers.entries) {
      final formName = entry.key;
      final questions = entry.value;
      data[formName] = {};
      for (final question in questions) {
        data[formName]![question.text] = question.answer!.value;
      }
    }
    final docRef = _firestore
        .collection('survey_responses')
        .doc(params.userId).set(data);
  }

  Future<void> _submitCompleteProfile(CompleteProfileSubmissionParams params) async{
    final docRef = _firestore
        .collection('Users')
        .doc(params.userId);

    await docRef.update({
      'faculity': params.selectedFaculity,
      'gender': params.gender,
      'academic_team': params.academicTeam,
      'place_of_residence': params.placeOfResidence,
      'academic_grade': params.academicGrade,
      'age': params.age,
      'has_visited_doctor_once': params.hasVisitedDoctorOnce,
      'has_completed_profile': true,
    });
  }

  @override
  Future<Either<Failure, bool>> submitAnswers({
    required SurveysSubmissionParams surveysParams,
    required CompleteProfileSubmissionParams completeProfileParams,
  }) async {
    try {
      await _submitSurveys(surveysParams);
      await _submitCompleteProfile(completeProfileParams);
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? ''));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
