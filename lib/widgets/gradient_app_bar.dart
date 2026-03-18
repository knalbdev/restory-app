import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      bottom: bottom,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary,
              Color.lerp(primary, Colors.black, 0.3)!,
            ],
          ),
        ),
      ),
    );
  }
}
