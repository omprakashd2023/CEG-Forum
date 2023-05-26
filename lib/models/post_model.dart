class Post {
  final String id;
  final String title;
  final String? description;
  final String? link;
  final String? image;
  final String communityName;
  final String communityAvatar;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String userName;
  final String userId;
  final String type;
  final DateTime createdAt;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.description,
    this.link,
    this.image,
    required this.communityName,
    required this.communityAvatar,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.userName,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
    String? link,
    String? image,
    String? communityName,
    String? communityAvatar,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? userName,
    String? userId,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      link: link ?? this.link,
      image: image ?? this.image,
      communityName: communityName ?? this.communityName,
      communityAvatar: communityAvatar ?? this.communityAvatar,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'link': link,
      'image': image,
      'communityName': communityName,
      'communityAvatar': communityAvatar,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'userName': userName,
      'userId': userId,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      communityName: map['communityName'] as String,
      communityAvatar: map['communityAvatar'] as String,
      upvotes: List<String>.from(
        (map['upvotes'] as List<String>),
      ),
      downvotes: List<String>.from(
        (map['downvotes'] as List<String>),
      ),
      commentCount: map['commentCount'] as int,
      userName: map['userName'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: List<String>.from(
        (map['awards'] as List<String>),
      ),
    );
  }
}
