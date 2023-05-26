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
    super.key,
    required this.uid,
  });

  void navigateToEditProfilePage(BuildContext context) {
    Routemaster.of(context).push(
      '/edit-profile/$uid',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (userData) => NestedScrollView(
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
                                backgroundImage: NetworkImage(userData.avatar),
                                radius: 35.0,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(20.0),
                              child: OutlinedButton(
                                onPressed: () =>
                                    navigateToEditProfilePage(context),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                    )),
                                child: const Text('Edit Profile'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${userData.name}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text('${userData.karma} karma'),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Divider(
                            thickness: 2.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getUserPostsProvider(uid)).when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final post = data[index];
                          return PostTile(
                            post: post,
                          );
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
            error: (error, stackTrace) => ErrorText(
              errorText: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
