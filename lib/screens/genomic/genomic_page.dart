import 'package:flutter/material.dart';

class GenomicPage extends StatelessWidget {
  const GenomicPage({super.key});
  final String title = "Mi perfil genético";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Text("Genomics page"),
      ),
    );
  }
}
