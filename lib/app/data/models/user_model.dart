class UserModel {
  final String uid;
  final String email;
  final String name;
  final DateTime joinedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'name': name,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      joinedAt: DateTime.parse(map['joinedAt']),
    );
  }
}
