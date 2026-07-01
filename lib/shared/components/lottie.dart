import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLottie extends StatefulWidget {
  const MyLottie({super.key, this.size = 120});

  final double size;

  @override
  State<MyLottie> createState() => _MyLottieState();
}

class _MyLottieState extends State<MyLottie> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), //fallback duration
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width : widget.size,
      height: widget.size,
      child : Lottie.asset(
        'assets/jsons/success.json',
        controller: _controller,
        repeat    : false,
        onLoaded  : (composition) {
          _controller
            ..duration = composition.duration
            ..forward(from: 0);
        },
      ),
    );
  }
}
