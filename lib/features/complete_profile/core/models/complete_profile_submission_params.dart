class CompleteProfileSubmissionParams {
  final String userId;
  final String selectedFaculity;
  final String gender;
  final String academicTeam;
  final String placeOfResidence;
  final String age;
  final String academicGrade;
  final bool hasVisitedDoctorOnce;

  CompleteProfileSubmissionParams({
    required this.userId,
    required this.selectedFaculity,
    required this.gender,
    required this.academicTeam,
    required this.placeOfResidence,
    required this.academicGrade,
    required this.age,
    required this.hasVisitedDoctorOnce,
  });
}
