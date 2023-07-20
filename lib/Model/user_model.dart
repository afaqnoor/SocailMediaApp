class UserModel {
  String? uid;
  String? email;
  String? username;
  String? phonenumber;

  UserModel({this.uid, this.email, this.username, this.phonenumber});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      phonenumber: map['phonenumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'phonenumber': phonenumber,
    };
  }
}
