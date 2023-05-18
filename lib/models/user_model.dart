class UserModel {
  final String name;
  final String email;
  final String avatar;
  final String banner;
  final String uid;
  final String isAuthenticated;
  final int karma;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.email,
    required this.avatar,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? avatar,
    String? banner,
    String? uid,
    String? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'avatar': avatar,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as String,
      karma: map['karma'] as int,
      awards: List<String>.from(
        (map['awards']),
      ),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, avatar: $avatar, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }
}
