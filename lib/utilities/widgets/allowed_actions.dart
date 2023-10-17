import 'package:social_network_utilities/utilities/utilities.dart';
import 'package:flutter/material.dart';

class AllowedActionsWidget<T extends AllowedActions, K extends Model>
    extends StatefulWidget {
  const AllowedActionsWidget(
      {super.key,
      required this.actions,
      required this.modelService,
      required this.model,
      required this.actionMapper});
  final T actions;
  final K model;
  final ModelService<K> modelService;

  final List<ActionData> Function(T actions, BuildContext context) actionMapper;
  @override
  State<AllowedActionsWidget> createState() => AllowedActionsWidgetState();
}

class AllowedActionsWidgetState extends State<AllowedActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.actionMapper(widget.actions, context).isEmpty
        ? const SizedBox()
        : PopupMenuButton(
            icon: Icon(
              Icons.more_horiz_outlined,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context) => widget
                .actionMapper(widget.actions, context)
                .map(
                  (e) => PopupMenuItem(
                      //onTap: e.onTap,
                      child: GestureDetector(
                    onTap: e.onTap,
                    child: Row(
                      children: [
                        Icon(e.icon),
                        const SizedBox(width: 10),
                        Text(e.title)
                      ],
                    ),
                  )),
                )
                .toList(),
          );
  }
}
