import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Utilities
import '../../../core/utils.dart';

//Widgets
import '../../../core/widgets/error_text.dart';
import '../../../core/widgets/loader.dart';

//Controllers
import '../../auth/controller/auth_controller.dart';
import '../../community/controller/community_controller.dart';
import '../controller/post_controller.dart';

//Models
import '../../../models/community_model.dart';

//todo: Refactor the below code
class AddPostTypePage extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypePage({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypePageState();
}

class _AddPostTypePageState extends ConsumerState<AddPostTypePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  File? postImage;
  Community? selectedCommunity;
  String postSource = 'My Account';

  List<Community> communities = [];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectPostImage() async {
    final result = await pickImage();
    if (result != null) {
      setState(() {
        postImage = File(result.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        postImage != null &&
        titleController.text.isNotEmpty) {
      if (postSource == 'My Account') {
        ref.read(postControllerProvider.notifier).shareImagePost(
              context: context,
              title: titleController.text.trim(),
              image: postImage,
              community: null, // Pass null for personal account
            );
      } else {
        if (selectedCommunity != null) {
          ref.read(postControllerProvider.notifier).shareImagePost(
                context: context,
                title: titleController.text.trim(),
                image: postImage,
                community: selectedCommunity ?? communities[0],
              );
        } else {
          showSnackBar(context, 'Please select a community');
        }
      }
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      if (postSource == 'My Account') {
        ref.read(postControllerProvider.notifier).shareTextPost(
              context: context,
              title: titleController.text.trim(),
              description: descriptionController.text.trim(),
              community: null, // Pass null for personal account
            );
      } else {
        if (selectedCommunity != null) {
          ref.read(postControllerProvider.notifier).shareTextPost(
                context: context,
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                community: selectedCommunity ?? communities[0],
              );
        } else {
          showSnackBar(context, 'Please select a community');
        }
      }
    } else if (widget.type == 'link' && titleController.text.isNotEmpty) {
      if (postSource == 'My Account') {
        ref.read(postControllerProvider.notifier).shareLinkPost(
              context: context,
              title: titleController.text.trim(),
              link: linkController.text.trim(),
              community: null, // Pass null for personal account
            );
      } else {
        if (selectedCommunity != null) {
          ref.read(postControllerProvider.notifier).shareLinkPost(
                context: context,
                title: titleController.text.trim(),
                link: linkController.text.trim(),
                community: selectedCommunity ?? communities[0],
              );
        } else {
          showSnackBar(context, 'Please select a community');
        }
      }
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  void selectPostSource(String source) {
    setState(() {
      postSource = source;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeLink = widget.type == 'link';
    final isTypeText = widget.type == 'text';
    final isLoading = ref.watch(postControllerProvider);
    final uid = ref.read(userProvider)!.uid;
    return isLoading
        ? const Center(
            child: Loader(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Post ${widget.type[0].toUpperCase()}${widget.type.substring(1)} - $postSource',
              ),
              actions: [
                TextButton(
                  onPressed: () => sharePost(),
                  child: const Text(
                    'Post',
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter the title',
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      maxLength: 40,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (isTypeImage)
                      GestureDetector(
                        onTap: selectPostImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(20.0),
                          strokeCap: StrokeCap.round,
                          color:
                              Theme.of(context).textTheme.displayMedium!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: postImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.file(
                                      postImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.add_a_photo),
                                  ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descriptionController,
                        maxLines: 7,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter the post description',
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter the link',
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10.0),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Select Post Source'),
                    ),
                    ListTile(
                      title: const Text('My Account'),
                      leading: Radio<String>(
                        value: 'My Account',
                        groupValue: postSource,
                        onChanged: (value) => selectPostSource(value!),
                      ),
                    ),
                    ListTile(
                      title: const Text('Community'),
                      leading: Radio<String>(
                        value: 'Community',
                        groupValue: postSource,
                        onChanged: (value) => selectPostSource(value!),
                      ),
                      subtitle: postSource != 'Community' ? null : ref.watch(userCommunityProvider(uid)).when(
                            data: (data) {
                              communities = data;
                              if (data.isEmpty) {
                                return const SizedBox();
                              }
                              return DropdownButton(
                                value: selectedCommunity ?? data.first,
                                items: data
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCommunity = value as Community;
                                  });
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              errorText: error.toString(),
                            ),
                            loading: () => const Loader(),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
