import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostsPage extends ConsumerWidget {
  const AddPostsPage({super.key});

  void navigateToAddPostTypePage(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double iconSize = 80.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => navigateToAddPostTypePage(context, 'image'),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => navigateToAddPostTypePage(context, 'text'),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                child: Center(
                  child: Icon(
                    Icons.font_download_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => navigateToAddPostTypePage(context, 'link'),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                child: Center(
                  child: Icon(
                    Icons.link_outlined,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
