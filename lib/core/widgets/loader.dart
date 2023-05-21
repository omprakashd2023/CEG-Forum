import 'package:flutter/material.dart';

// Constants
import '../../../core/constants/constants.dart';

class Loader extends StatefulWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  final double size = 48.0;
  final ImageProvider<Object> defaultImageProvider =
      const AssetImage(Constants.logoPath);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween(begin: -0.05, end: 0.05).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(_animation.value * widget.size, 0.0),
            child: Transform.rotate(
              angle: _animationController.value * 2 * 3.14159,
              child: Image(
                image: widget.defaultImageProvider,
                width: widget.size,
                height: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}


/* 
  * Traditional Loader
  const Center(
      child: CircularProgressIndicator(),
  );
*/