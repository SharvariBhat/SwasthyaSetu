import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;
  final double elevation;
  final VoidCallback? onTap;
  final BorderSide? borderSide;

  const CustomCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.backgroundColor,
    this.elevation = 2,
    this.onTap,
    this.borderSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: elevation,
        color: backgroundColor ?? AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
