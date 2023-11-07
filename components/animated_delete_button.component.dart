import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedDeleteButton extends StatefulWidget {
  const AnimatedDeleteButton({super.key, required this.deleteCallback});
  final Function deleteCallback;

  @override
  State<AnimatedDeleteButton> createState() => _AnimatedDeleteButtonState();
}

class _AnimatedDeleteButtonState extends State<AnimatedDeleteButton> {
  bool isAnimating = false;

  void startAnimation() {
    setState(() {
      isAnimating = true;
    });
  }

  void stopAnimation() {
    setState(() {
      isAnimating = false;
    });
  }

  bool cancel = false;
  void iniciar() {
    Timer(const Duration(seconds: 2), () async {
      if (!cancel) {
        await widget.deleteCallback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (_) {
        cancel = true;
        stopAnimation();
      },
      onPanDown: (_) {
        cancel = false;
        startAnimation();
        iniciar();
      },
      child: Center(
          child: Animate(
        effects: isAnimating
            ? [
                const ShakeEffect(
                  curve: Curves.easeInCubic,
                  duration: Duration(seconds: 2),
                ),
                const ScaleEffect(
                  begin: Offset(1, 1),
                  end: Offset(2, 2),
                  curve: Curves.easeInCubic,
                  duration: Duration(milliseconds: 1950),
                ),
                const ScaleEffect(
                  begin: Offset(1, 1),
                  end: Offset(.5, .5),
                  curve: Curves.easeOutCubic,
                  duration: Duration(milliseconds: 50),
                  delay: Duration(milliseconds: 1950),
                ),
              ]
            : null,
        child: Container(
          height: 40,
          width: 40,
          child: Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
        ),
      )),
    );
  }
}
