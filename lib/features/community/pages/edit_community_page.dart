import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

//Models
import '../../../models/community_model.dart';

//Utilities
import '../../../core/utils.dart';

//Constants
import '../../../core/constants/constants.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

//Controllers
import '../controller/community_controller.dart';

class EditCommunityPage extends ConsumerStatefulWidget {
  const EditCommunityPage({required this.name, super.key});

  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityPageState();
}

class _EditCommunityPageState extends ConsumerState<EditCommunityPage> {
  File? bannerImage;
  File? avatarImage;
  void selectBannerImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        bannerImage = File(result.files.first.path!);
      });
    }
  }

  void selectAvatarImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        avatarImage = File(result.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          avatarImage: avatarImage,
          bannerImage: bannerImage,
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(20.0),
                              strokeCap: StrokeCap.round,
                              color: Theme.of(context).textTheme
                                  .displayMedium!.color!,
                              child: Container(
                                width: double.infinity,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: bannerImage != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.file(
                                          bannerImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : community.banner.isEmpty ||
                                            community.banner ==
                                                Constants.bannerDefault
                                        ? const Center(
                                            child: Icon(Icons.add_a_photo),
                                          )
                                        : Image.network(
                                            community.banner,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20.0,
                            left: 10.0,
                            child: GestureDetector(
                              onTap: selectAvatarImage,
                              child: avatarImage != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(avatarImage!),
                                      radius: 32.0,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(community.avatar),
                                      radius: 32.0,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          error: (error, stackTrace) =>
              const ErrorText(errorText: 'Error loading data'),
          loading: () => const Loader(),
        );
  }
}
