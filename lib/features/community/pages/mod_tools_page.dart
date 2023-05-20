import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsPage extends StatelessWidget {
  const ModToolsPage({super.key, required this.name});
  final String name;

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Moderators'),
            leading: const Icon(Icons.add_moderator),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Edit Community'),
            leading: const Icon(Icons.edit),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
