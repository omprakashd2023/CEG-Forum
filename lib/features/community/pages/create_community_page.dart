import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import '../../../core/widgets/loader.dart';

//Utilities
import '../../../core/utils.dart';

//Controller
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

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  void createCommunity() {
    final communityName = _communityNameController.text.trim();
    if (communityName.isEmpty) {
      showSnackBar(context, 'Community name cannot be empty');
      return;
    }
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityName, context);
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
