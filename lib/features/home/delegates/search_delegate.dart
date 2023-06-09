import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:any_link_preview/any_link_preview.dart';

//Models
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../models/community_model.dart';

//Controllers
import '../../community/controller/community_controller.dart';
import '../../user_profile/controller/user_profile_controller.dart';
import '../../posts/controller/post_controller.dart';

//Widgets
import '../../../core/widgets/loader.dart';

class SearchDelegateWidget extends SearchDelegate {
  final WidgetRef ref;
  SearchDelegateWidget({
    required this.ref,
  });

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/ceg/$communityName');
  }

  void navigateToUser(BuildContext context, String uid) {
    Routemaster.of(context).push('/user/$uid');
  }

  void navigateToPost(BuildContext context, String postId) {
    Routemaster.of(context).push('/post/$postId/comments');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final userSuggestions = ref.watch(searchUsersProvider(query));
    final communitySuggestions = ref.watch(searchCommunityProvider(query));
    final postSuggestions = ref.watch(getSearchPostsProvider(query));

    return userSuggestions is AsyncLoading ||
            communitySuggestions is AsyncLoading
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                if (query.isNotEmpty &&
                    userSuggestions is AsyncData<List<UserModel>> &&
                    userSuggestions.value.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Users'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = userSuggestions.value[index];
                      return ListTile(
                        onTap: () => navigateToUser(context, user.uid),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatar),
                        ),
                        title: Text('ceg/${user.name}'),
                        subtitle: Text('${user.karma} Karma'),
                      );
                    },
                    itemCount: userSuggestions.value.length,
                  ),
                  const Divider(),
                ],
                if (query.isNotEmpty &&
                    communitySuggestions is AsyncData<List<Community>> &&
                    communitySuggestions.value.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Communities'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final community = communitySuggestions.value[index];
                      return ListTile(
                        onTap: () =>
                            navigateToCommunity(context, community.name),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                        title: Text('ceg/${community.name}'),
                        subtitle: Text('${community.members.length} members'),
                      );
                    },
                    itemCount: communitySuggestions.value.length,
                  ),
                  const Divider(),
                ],
                if (query.isNotEmpty &&
                    postSuggestions is AsyncData<List<Post>> &&
                    postSuggestions.value.isNotEmpty) ...[
                  const ListTile(
                    title: Text('Posts'),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final post = postSuggestions.value[index];
                      return GestureDetector(
                        onTap: () => navigateToPost(context, post.id),
                        child: SizedBox(
                          height: 200,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (post.image != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      post.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                                if (post.link != null) ...[
                                  AnyLinkPreview(
                                    link: post.link!,
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                  ),
                                ] else if (post.description != null) ...[
                                  Center(
                                    child: Text(
                                      post.description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.black54,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              post.communityAvatar != null
                                                  ? NetworkImage(
                                                      post.communityAvatar!,
                                                    )
                                                  : NetworkImage(
                                                      post.userAvatar,
                                                    ),
                                          radius: 18.0,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (post.communityName !=
                                                    null) ...[
                                                  Text(
                                                    'ceg/${post.communityName}',
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'u/${post.userName}',
                                                        style: const TextStyle(
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 12.0,
                                                      ),
                                                    ],
                                                  ),
                                                ] else ...[
                                                  Text(
                                                    'u/${post.userName}',
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: postSuggestions.value.length,
                  ),
                  const Divider(),
                ],
              ],
            ),
          );
  }
}
