import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String name;
  final String content;
  const TextSection({super.key, required this.name, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(content, style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }
}
