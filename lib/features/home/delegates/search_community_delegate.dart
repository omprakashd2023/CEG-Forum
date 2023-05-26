import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

//Controllers
import '../../community/controller/community_controller.dart';

//Widgets
import '../../../core/widgets/loader.dart';
import '../../../core/widgets/error_text.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate({
    required this.ref,
  });

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/ceg/$communityName');
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
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                onTap: () => navigateToCommunity(context, community.name),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text('ceg/${community.name}'),
              );
            },
            itemCount: communities.length,
          ),
          error: (error, stackTrace) => ErrorText(
            errorText: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
