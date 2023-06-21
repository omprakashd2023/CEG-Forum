class Comment {
  final String id;
  final String comment;
  final DateTime createdAt;
  final String postId;
  final String userName;
  final String userId;
  final String userAvatar;
  Comment({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.postId,
    required this.userName,
    required this.userId,
    required this.userAvatar,
  });

  Comment copyWith({
    String? id,
    String? comment,
    DateTime? createdAt,
    String? postId,
    String? userName,
    String? userId,
    String? userAvatar,
  }) {
    return Comment(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'userName': userName,
      'userId': userId,
      'userAvatar': userAvatar,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      comment: map['comment'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      userName: map['userName'] as String,
      userId: map['userId'] as String,
      userAvatar: map['userAvatar'] as String,
    );
  }
}
