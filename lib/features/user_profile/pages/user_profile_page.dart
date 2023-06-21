import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Controllers
import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/post_tile.dart';

class UserProfilePage extends ConsumerWidget {
  final String uid;
  const UserProfilePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  void navigateToEditProfilePage(BuildContext context) {
    Routemaster.of(context).push(
      '/edit-profile/$uid',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider)!;
    final isCurrentUser = currentUser.uid == uid;

    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (userData) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150.0,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              userData.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.all(20.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userData.avatar),
                                  radius: 35.0,
                                ),
                              ),
                              if (isCurrentUser)
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(20.0),
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        navigateToEditProfilePage(context),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                      ),
                                    ),
                                    child: const Text('Edit Profile'),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'u/${userData.name}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${userData.karma} karma',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  userData.description.isNotEmpty
                                      ? userData.description
                                      : 'No description yet',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ref.watch(getUserPostsProvider(uid)).when(
                            data: (data) {
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final post = data[index];
                                  return PostTile(post: post);
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              print(error.toString());
                              return ErrorText(errorText: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
