import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DefaultErrorMessage extends StatelessWidget {
  const DefaultErrorMessage({
    super.key,
    required this.screenSize,
    required this.icon,
    required this.text,
  });
  final Size screenSize;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150,
        width: screenSize.width * 0.9,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(5, 5),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            const Gap(5),
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
