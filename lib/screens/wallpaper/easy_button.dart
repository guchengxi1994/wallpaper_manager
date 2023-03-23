import 'package:flutter/material.dart';

class EasyButton extends StatelessWidget {
  const EasyButton(
      {super.key,
      required this.onClick,
      required this.child,
      this.height = 30,
      this.width = 30});
  final VoidCallback onClick;
  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: child,
      ),
    );
  }
}
