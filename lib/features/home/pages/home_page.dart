import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Controller
import '../../auth/controller/auth_controller.dart';

//Widgets
import '../widgets/community_list_drawer.dart';
import '../widgets/user_profile_drawer.dart';

//Delegates
import '../delegates/search_community_delegate.dart';

//Constants
import '../../../core/constants/constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void showSearchDelegate(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: SearchCommunityDelegate(
        ref: ref,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => showSearchDelegate(context, ref),
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayEndDrawer(context),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
            );
          }),
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: BottomNavigationBar(
        selectedItemColor: Theme.of(context).iconTheme.color,
        backgroundColor: Theme.of(context).colorScheme.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Post',
          ),
        ],
        onTap: (value) => onPageChanged(value),
        currentIndex: _page,
      ),
    );
  }
}
