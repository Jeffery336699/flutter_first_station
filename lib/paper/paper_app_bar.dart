import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first_station/ext/ex_widget.dart';

class PaperAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClear;
  final VoidCallback? onBack;
  final VoidCallback? onRevocation;

  const PaperAppBar({
    Key? key,
    required this.onClear,
    this.onBack,
    this.onRevocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackUpButtons(
        onBack: onBack,
        onRevocation: onRevocation,
      ),
      leadingWidth: 100,
      title: Text('画板绘制'),
      actions: [
        IconButton(
            splashRadius: 20,
            onPressed: onClear,
            icon: Icon(CupertinoIcons.delete, size: 20))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BackUpButtons extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onRevocation;

  const BackUpButtons({
    Key? key,
    required this.onBack,
    required this.onRevocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const BoxConstraints cts = BoxConstraints(minHeight: 32, minWidth: 32);
    Color backColor = onBack == null ? Colors.grey : Colors.black;
    Color revocationColor = onRevocation == null ? Colors.grey : Colors.black;
    return Center(
      child: Wrap(
        children: [
          Transform.scale(
            // 当 scaleX 的值为 -1 时，它会将子组件沿其中心点进行水平翻转（或称为镜像）。在这个例子中，IconButton
            // 里的 Icons.next_plan_outlined 图标（通常指向右边）会被水平翻转，从而看起来像一个指向左边的“后退”或“上一步”图标。
            scaleX: -1,
            child: IconButton(
              splashRadius: 20,
              constraints: cts,
              onPressed: onBack,
              icon: Icon(Icons.next_plan_outlined, color: backColor),
            ),
          ).withBorder(),
          IconButton(
            splashRadius: 20,
            onPressed: onRevocation,
            constraints: cts,
            icon: Icon(Icons.next_plan_outlined, color: revocationColor),
          )
        ],
      ),
    );
  }
}
