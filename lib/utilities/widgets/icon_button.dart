import 'package:flutter/material.dart';

class SocialUtilIconButton extends StatefulWidget {
  const SocialUtilIconButton(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.color,
      this.display = true})
      : super(key: key);
  final String title;
  final IconData icon;
  final void Function() onTap;
  final bool display;
  final Color? color;

  @override
  State<SocialUtilIconButton> createState() => _SocialUtilIconButtonState();
}

class _SocialUtilIconButtonState extends State<SocialUtilIconButton> {
  @override
  Widget build(BuildContext context) {
    return widget.display
        ? GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Icon(
                    widget.icon,
                    size: 25,
                    color: widget.color,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 9, color: widget.color),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
