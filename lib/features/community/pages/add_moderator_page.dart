import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Controllers
import '../controller/community_controller.dart';
import '../../auth/controller/auth_controller.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

class AddModeratorPage extends ConsumerStatefulWidget {
  final String name;
  const AddModeratorPage({required this.name, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddModeratorPageState();
}

class _AddModeratorPageState extends ConsumerState<AddModeratorPage> {
  Set<String> uids = {};
  int cnt = 0;
  int ctr = 0;
  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveModerators() {
    ref.read(communityControllerProvider.notifier).addModerators(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Moderator'),
        actions: [
          IconButton(
            onPressed: () => saveModerators(),
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemBuilder: (context, index) {
                print(community.members);
                final member = community.members[index];
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.moderators.contains(user.uid) &&
                            !uids.contains(user.uid) &&
                            cnt == 0) {
                          uids.add(user.uid);
                          ctr == community.moderators.length - 1
                              ? cnt = 1
                              : ctr++;
                        }
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (value) {
                            if (value!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(errorText: error.toString()),
                      loading: () => const Loader(),
                    );
              },
              itemCount: community.members.length,
            ),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
