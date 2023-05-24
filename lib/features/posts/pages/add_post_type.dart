import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
