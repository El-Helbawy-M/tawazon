import 'package:flutter/material.dart';

class TitledComponent extends StatelessWidget {
  const TitledComponent({
    super.key,
    required this.title,
    required this.child,
    this.showAll,
    this.titleStyle,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.childPadding = const EdgeInsets.all(0),
  });

  final Widget child;
  final String title;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry childPadding;

  final Function()? showAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: titlePadding,
          child: Row(
            children: [
              Text(title, style: titleStyle ?? TextStyle(fontSize:20, fontWeight: FontWeight.w700)),
              Spacer(),
              if (showAll != null)
                InkWell(
                  onTap: showAll,
                  child: Text(
                    "Show All",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: childPadding,
          child: child,
        ),
      ],
    );
  }
}
