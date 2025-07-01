class User {
  String? id;
  String? name;
  String? email;
  String? facultyName;
  String? universityName;
  bool hasCompletedProfile = false;

  User({
    this.id,
    this.name,
    this.email,
    this.facultyName,
    this.universityName,
    this.hasCompletedProfile = false,
  });

  User.guest(){
    id = 'guest';
    name = 'Guest';
    email = '';
    facultyName = '';
    universityName = '';
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    facultyName = json['faculty'];
    universityName = json['university'];
    hasCompletedProfile = json['has_completed_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['faculty'] = this.facultyName;
    data['university'] = this.universityName;
    data['has_completed_profile'] = this.hasCompletedProfile;
    return data;
  }
}
