import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? titleColor;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleColor = Colors.white,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 4.0,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: titleColor),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: elevation,
      actions: actions,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
