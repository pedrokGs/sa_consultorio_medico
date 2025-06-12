import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  final String? title;
  final Widget? leading;
  final Widget? actions;
  final bool? automaticallyImplyLeading;

  const CustomAppBar({super.key, this.title, this.leading, this.actions, this.automaticallyImplyLeading});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.automaticallyImplyLeading ?? false,
      title: widget.title != null ? Text(widget.title!) : null,
      leading: widget.leading ?? Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: widget.actions != null ? [widget.actions!] : null,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }
}