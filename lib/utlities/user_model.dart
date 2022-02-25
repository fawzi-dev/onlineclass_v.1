class UserModel {
  String? username;
  String? userRole;
  String? name;
  String? stage;
  String? password;

// receiving data
  UserModel({ this.username,this.userRole,this.name,this.stage,this.password});
  factory UserModel.fromMap(map) {
    return UserModel(
      username: map['username'],
      password: map['password'],
      name: map['name'],
      userRole: map['userrole'],
      stage: map['stage'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'name':name,
      'userrole': userRole,
      'stage':stage
    };
  }
}