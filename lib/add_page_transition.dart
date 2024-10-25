import 'package:flutter/material.dart';

class AddPageTransition extends PageRouteBuilder {
  final Widget page;
  final Widget background;

  AddPageTransition({required this.background, required this.page})
      : super(
        transitionDuration: const Duration(microseconds: 1),
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) => Stack(
            children: [
              background,
              page,
            ],
          ),
        );
}
