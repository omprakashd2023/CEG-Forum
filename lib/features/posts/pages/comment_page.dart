import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/post_tile.dart';
import '../widgets/comment_tile.dart';

//Controllers
import '../controller/post_controller.dart';
import '../../auth/controller/auth_controller.dart';

//Models
import '../../../models/post_model.dart';

class CommentPage extends ConsumerStatefulWidget {
  final String postId;
  const CommentPage({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = user.isAuthenticated == 'false' ? true : false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Column(
                children: [
                  PostTile(
                    post: post,
                  ),
                  TextField(
                    enabled: !isGuest,
                    onSubmitted: (_) => addComment(post),
                    controller: commentController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'What are your thoughts?',
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (comments) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return CommentTile(
                                  comment: comment,
                                );
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          errorText: error.toString(),
                        ),
                        loading: () => const Loader(),
                      )
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              errorText: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
