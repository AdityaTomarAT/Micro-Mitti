class UserModel {
  String userId;
  String firstname;
  String lastname;
  String email;
  String mobilenumber;
  String password;

  UserModel({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobilenumber,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'mobilenumber': mobilenumber,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      mobilenumber: map['mobilenumber'],
      password: map['password'],
    );
  }
}
