import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import '../../core/widgets/post_tile.dart';

//Widgets
import '../../core/widgets/error_text.dart';
import '../../core/widgets/loader.dart';

//Controller
import '../posts/controller/post_controller.dart';

class FeedsPage extends ConsumerWidget {
  const FeedsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getLatestPostsProvider).when(
          data: (posts) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostTile(
                  post: post,
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
            errorText: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
