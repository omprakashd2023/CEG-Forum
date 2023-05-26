import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:routemaster/routemaster.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

//Constants
import '../constants/constants.dart';

//Models
import '../../../models/post_model.dart';

//Controllers
import '../../features/auth/controller/auth_controller.dart';
import '../../features/posts/controller/post_controller.dart';
import '../../features/community/controller/community_controller.dart';

class PostTile extends ConsumerWidget {
  final Post post;
  const PostTile({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvotePost(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvotePost(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(
          post: post,
          award: award,
          context: context,
        );
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user/${post.userId}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/ceg/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';
    final user = ref.watch(userProvider)!;
    final isGuest = user.isAuthenticated == 'false' ? true : false;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        post.communityAvatar,
                                      ),
                                      radius: 16.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ceg/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            'u/${post.userName}',
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.userId == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: const Icon(Icons.delete),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 25.0,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final award = post.awards[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Image.asset(
                                      Constants.awards[award]!,
                                      height: 20,
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: AnyLinkPreview(
                                link: post.link!,
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        isGuest ? () {} : () => upvotePost(ref),
                                    icon: Icon(
                                      Constants.up,
                                      size: 25.0,
                                      color: post.upvotes.contains(user.uid)
                                          ? Colors.red
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length}',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: isGuest
                                        ? () {}
                                        : () => downvotePost(ref),
                                    icon: Icon(
                                      Constants.down,
                                      size: 25.0,
                                      color: post.downvotes.contains(user.uid)
                                          ? Colors.blue
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.downvotes.length}',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      Icons.comment,
                                    ),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  //todo: Add Share Button
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                    data: (community) {
                                      if (community.moderators
                                          .contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(
                                              Icons.admin_panel_settings),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      errorText: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                              isGuest
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 4),
                                                itemCount: user.awards.length,
                                                itemBuilder: (context, index) {
                                                  final award =
                                                      user.awards[index];
                                                  return GestureDetector(
                                                    onTap: () => awardPost(
                                                        ref, award, context),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Image.asset(
                                                          Constants
                                                              .awards[award]!),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.card_giftcard,
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
