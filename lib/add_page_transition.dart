import 'package:flutter/material.dart';

class AddPageTransition extends PageRouteBuilder {
  final Widget page;

  AddPageTransition({required this.page})
      : super(
            transitionDuration: const Duration(microseconds: 1),
            pageBuilder: (context, animation1, animation2) => page,
            transitionsBuilder: (context, animation1, animation2, child) => child);

  @override
  bool get opaque => false;
}
