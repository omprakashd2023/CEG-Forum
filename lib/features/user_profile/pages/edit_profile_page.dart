import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Utilities
import '../../../core/utils.dart';

//Constants
import '../../../core/constants/constants.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

//Theme Data
import '../../../theme/colours.dart';

//Controllers
import '../controller/user_profile_controller.dart';
import '../../auth/controller/auth_controller.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String uid;
  const EditProfilePage({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  File? bannerImage;
  File? avatarImage;
  late TextEditingController nameController;
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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          avatarImage: avatarImage,
          bannerImage: bannerImage,
          name: nameController.text.trim(),
          context: context,
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: () => save(),
                  child: const Text('Save'),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: isLoading
                ? const Center(
                    child: Loader(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
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
                                  color: Theme.of(context).primaryColor,
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
                                        : user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault
                                            ? const Center(
                                                child: Icon(Icons.add_a_photo),
                                              )
                                            : Image.network(
                                                user.banner,
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
                                          backgroundImage:
                                              FileImage(avatarImage!),
                                          radius: 32.0,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user.avatar),
                                          radius: 32.0,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTrace) =>
              const ErrorText(errorText: 'Error loading data'),
          loading: () => const Loader(),
        );
  }
}
