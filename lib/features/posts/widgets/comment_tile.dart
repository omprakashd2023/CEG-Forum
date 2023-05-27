import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Models
import '../../../models/comment_model.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    super.key,
    required this.comment,
  });
  String timeAgoSinceDate(Duration difference, BuildContext context) {
    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider)!;
    // final isCurrentUser = user.uid == comment.userId;
    final now = DateTime.now();
    final createdAtDateTime = comment.createdAt;
    final difference = now.difference(createdAtDateTime);

    final timeAgo = timeAgoSinceDate(difference, context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.userAvatar),
                radius: 18.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'u/${comment.userName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(comment.comment),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //todo: Add Nested Comment Section
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.reply),
              ),
              const Text('Reply'),
            ],
          ),
        ],
      ),
    );
  }
}
