class Community {
  final String id;
  final String name;
  // final String description;
  final String avatar;
  final String banner;
  final List<String> members;
  final List<String> moderators;
  Community({
    required this.id,
    required this.name,
    required this.avatar,
    required this.banner,
    required this.members,
    required this.moderators,
  });

  Community copyWith({
    String? id,
    String? name,
    String? avatar,
    String? banner,
    List<String>? members,
    List<String>? moderators,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      members: members ?? this.members,
      moderators: moderators ?? this.moderators,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'banner': banner,
      'members': members,
      'moderators': moderators,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      banner: map['banner'] as String,
      members: List<String>.from(
        (map['members']),
      ),
      moderators: List<String>.from(
        (map['moderators']),
      ),
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name, avatar: $avatar, banner: $banner, members: $members, moderators: $moderators)';
  }
}
