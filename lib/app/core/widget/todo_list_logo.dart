import 'package:flutter/material.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';

class ArtListLogo extends StatelessWidget {
  const ArtListLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 200,
        ),
        Text(
          'Art Plastic',
          style: context.titleStyle,
        ),
      ],
    );
  }
}
