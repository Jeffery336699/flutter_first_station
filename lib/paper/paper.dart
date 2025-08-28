import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_first_station/ext/ex_widget.dart';
import 'package:flutter_first_station/paper/color_selector.dart';
import 'package:flutter_first_station/paper/conform_dialog.dart';

import 'model.dart';
import 'paper_app_bar.dart';
import 'stork_width_selector.dart';

class Paper extends StatefulWidget {
  const Paper({Key? key}) : super(key: key);

  @override
  State<Paper> createState() => _PaperState();
}

class _PaperState extends State<Paper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  List<Line> _lines = []; // 线列表

  int _activeColorIndex = 0; // 颜色激活索引
  int _activeStorkWidthIndex = 0; // 线宽激活索引

  // 支持的颜色
  final List<Color> supportColors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.grey,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  // 支持的线粗
  final List<double> supportStorkWidths = [1, 2, 4, 6, 8, 10];

  final List<Line> _historyLines = [];

  void _back() {
    Line line = _lines.removeLast();
    _historyLines.add(line);
    setState(() {});
  }

  void _revocation() {
    Line line = _historyLines.removeLast();
    _lines.add(line);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PaperAppBar(
        onClear: _showClearDialog,
        onBack: _lines.isEmpty ? null : _back,
        onRevocation: _historyLines.isEmpty ? null : _revocation,
      ),
      //   `Stack` 的大小由其 `fit` 属性和非定位（non-positioned）的子组件决定。
      //
      // 1.  **默认情况 (`fit` 为 `StackFit.loose`)**: `Stack` 的大小会调整为刚好包裹住所有**非定位**的子组件。
      // 定位的子组件（如 `Positioned`）不会影响 `Stack` 的大小。
      // 2.  **`fit` 为 `StackFit.expand`**: `Stack` 会扩展以填充其父组件提供的约束。
      // 3.  **`fit` 为 `StackFit.passthrough`**: `Stack` 不会对其非定位子组件施加额外的约束。
      //
      // 在您的代码中：
      // *   `Stack` 有两个子组件：一个 `GestureDetector` 和一个 `Positioned`。
      // *   `Positioned` 是定位组件，不影响 `Stack` 的大小。
      // *   `GestureDetector` 是非定位组件。其内部的 `ConstrainedBox` 设置了 `300x300` 的固定大小。
      //
      // 因此，这个 `Stack` 的大小由 `GestureDetector` 决定，即 `300x300`（不考虑 `withBorder()` 可能增加的边框或内边距）。
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: CustomPaint(
              painter: PaperPainter(lines: _lines),
              ///这里目的是借助非定位组件 ConstrainedBox 来决定 Stack 的大小（撑满可用空间）
              child: ConstrainedBox(
                  constraints:
                      /*BoxConstraints.tightFor(width: 300.0, height: 300.0)*/const BoxConstraints.expand()),
            ),
          ).withBorder(color: Colors.green),
          Positioned(
            bottom: 0,
            // 这里设置宽度为屏幕宽度，为的是子widget Row 能够占满屏幕宽度，从而让 Expanded 正常工作
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: ColorSelector(
                    supportColors: supportColors,
                    activeIndex: _activeColorIndex,
                    onSelect: _onSelectColor,
                  ),
                ),
                StorkWidthSelector(
                  supportStorkWidths: supportStorkWidths,
                  color: supportColors[_activeColorIndex],
                  activeIndex: _activeStorkWidthIndex,
                  onSelect: _onSelectStorkWidth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    String msg = "您的当前操作会清空绘制内容，是否确定删除!";
    showDialog(
        context: context,
        builder: (ctx) => ConformDialog(
              title: '清空提示',
              conformText: '确定',
              msg: msg,
              onConform: _clear,
            ));
  }

  void _clear() {
    _lines.clear();
    _historyLines.clear();
    Navigator.of(context).pop();
    setState(() {});
  }

  void _onPanStart(DragStartDetails details) {
    // 开始新的线
    _lines.add(Line(
      points: [details.localPosition],
      strokeWidth: supportStorkWidths[_activeStorkWidthIndex],
      color: supportColors[_activeColorIndex],
    ));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    Offset point = details.localPosition;
    // 在新的线上添加点，线上必有点（_onPanStart中有添加）
    double distance = (_lines.last.points.last - point).distance;
    // 两点之间距离大于5时，才添加到点列表中，避免点过密
    if (distance > 5) {
      _lines.last.points.add(details.localPosition);
      setState(() {});
    }
  }

  void _onSelectStorkWidth(int index) {
    if (index != _activeStorkWidthIndex) {
      setState(() {
        _activeStorkWidthIndex = index;
      });
    }
  }

  void _onSelectColor(int index) {
    if (index != _activeColorIndex) {
      setState(() {
        _activeColorIndex = index;
      });
    }
  }

}

class PaperPainter extends CustomPainter {
  PaperPainter({
    required this.lines,
  }) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  late Paint _paint;
  final List<Line> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < lines.length; i++) {
      drawLine(canvas, lines[i]);
    }
  }

  ///根据点位绘制线
  void drawLine(Canvas canvas, Line line) {
    _paint.color = line.color;
    _paint.strokeWidth = line.strokeWidth;
    canvas.drawPoints(PointMode.polygon, line.points, _paint);
  }

  /**
   * `shouldRepaint` 方法用于决定 `CustomPaint` 是否需要重绘。当 `CustomPaint` 的 `painter` 属性被赋予一个新的实例时，Flutter 框架会调用这个方法。

      ### `=> true` 的含义

      `bool shouldRepaint(CustomPainter oldDelegate) => true;`

      这行代码意味着，无论何时 `CustomPaint` widget 重建（即使绘制内容没有变化），`paint` 方法都**总是**会被调用，从而强制重绘。在开发初期或动画场景中，这很方便，但对于性能敏感的应用来说，这通常是低效的。

      ### 在实际项目中的优化

      为了优化性能，`shouldRepaint` 应该仅在绘制内容确实发生变化时才返回 `true`。这通过比较新旧 `painter` 的属性来实现。`oldDelegate` 参数就是前一个 `painter` 的实例。

   **以您的 `PaperPainter`
      ```dart
      @override
      bool shouldRepaint(PaperPainter oldDelegate) => oldDelegate.lines != lines;
      ```

   **说明：**

      1.  我们将 `oldDelegate` 的类型从 `CustomPainter` 改为更具体的 `PaperPainter`，这样可以直接访问 `lines` 属性。
      2.  `oldDelegate.lines != lines` 这句代码比较了旧 `painter` 的 `lines` 列表和当前 `painter` 的 `lines` 列表。
      3.  在您的代码中，当用户绘制时，`_lines` 列表的实例会改变（通过 `add` 或 `removeLast` 等操作），因此 `oldDelegate.lines != lines` 会返回 `true`，触发重绘。
      4.  如果 `_PaperState` 因其他原因重建（例如，父组件重建），但 `_lines` 列表本身没有变化，那么 `oldDelegate.lines == lines` 会是 `true`，`shouldRepaint` 返回 `false`，从而避免了不必要的重绘，提升了性能。
   */
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
