import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Widgets
import '../widgets/community_list_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: (){},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}
