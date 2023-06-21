import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import '../../../core/widgets/loader.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
import '../../auth/controller/auth_controller.dart';
import '../controller/community_controller.dart';

class CreateCommunityPage extends ConsumerStatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityPageState();
}

class _CreateCommunityPageState extends ConsumerState<CreateCommunityPage> {
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _communityDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _communityNameController.dispose();
    _communityDescriptionController.dispose();
    super.dispose();
  }

  void createCommunity() {
    final communityName = _communityNameController.text.trim();
    final communityDescription = _communityDescriptionController.text.trim();
    if (communityName.isEmpty) {
      showSnackBar(context, 'Community name cannot be empty');
      return;
    }
    if (communityDescription.isEmpty) {
      showSnackBar(context, 'Community description cannot be empty');
      return;
    }

    final user = ref.watch(userProvider)!;
    ref.read(communityControllerProvider.notifier).createCommunity(
        communityName, communityDescription, user.name, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Community Name'),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _communityNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter a Community Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18.0),
                    ),
                    maxLength: 25,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Description'),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    controller: _communityDescriptionController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter a Description',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18.0),
                    ),
                    maxLength: 150,
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () => createCommunity(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Create Community',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
