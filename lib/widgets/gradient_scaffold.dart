import 'package:flutter/material.dart';
import '../theme/lerno_theme.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = true,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: LernoColors.scaffoldDark,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LernoColors.scaffoldGradient,
        ),
        child: body,
      ),
    );
  }
}