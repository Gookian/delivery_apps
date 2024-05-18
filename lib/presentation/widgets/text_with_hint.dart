import 'package:flutter/material.dart';

class TextWithHint extends StatelessWidget {
  final String text;
  final String hint;

  const TextWithHint({super.key, required this.text, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
        Text(hint, style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }
}