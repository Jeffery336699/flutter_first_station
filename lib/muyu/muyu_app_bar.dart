import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MuyuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTapHistory;

  const MuyuAppBar({
    Key? key,
    required this.onTapHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("电子木鱼"),
      actions: [
        IconButton(
          onPressed: onTapHistory,
          icon: const Icon(Icons.history),
        )
      ],
    );
  }

  /**
  `PreferredSizeWidget` 是一个接口（interface），它允许一个 Widget 指定其首选大小。

   **在这个例子中的作用：*

      `MuyuAppBar` 是一个自定义的 AppBar。当您将一个 Widget 放到 `Scaffold` 的 `appBar` 属性中时，`Scaffold` 需要知道这个 AppBar 的高度，以便为页面的主体（`body`）留出正确的空间，防止内容被 AppBar 遮挡。

      通过实现 `PreferredSizeWidget` 并重写 `preferredSize` getter 方法，`MuyuAppBar` 告诉 `Scaffold` 它希望的高度是 `kToolbarHeight`（Flutter 中标准的 AppBar 高度）。这样 `Scaffold` 就能正确地布局页面。

   **在实际项目中的使用：*

      `PreferredSizeWidget` 最常见的用途就是创建自定义的 `AppBar`。当标准的 `AppBar` 无法满足你的 UI 设计（例如，需要更复杂的布局、动画或者不同的高度）时，你可以创建一个自己的 Widget，然后实现 `PreferredSizeWidget` 接口，这样它就可以被用在 `Scaffold.appBar` 中了。

      简而言之，任何时候你想创建一个自定义组件来替代 `AppBar`，你都应该实现 `PreferredSizeWidget`。
   */
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
