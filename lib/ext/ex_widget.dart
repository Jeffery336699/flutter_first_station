// lib/extensions/widget_border_extension.dart
import 'package:flutter/material.dart';

extension WidgetBorderExtension on Widget {
  /// 给任意组件添加边框
  Widget withBorder({
    Color color = Colors.black,
    double width = 1,
    double radius = 0,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? background,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: color, width: width),
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
      ),
      child: this,
    );
  }

  /// 虚线边框（使用 `CustomPainter` 简易实现）
  Widget withDashedBorder({
    Color color = Colors.black,
    double strokeWidth = 1,
    double radius = 0,
    double dash = 4,
    double gap = 2,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? background,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: color,
          strokeWidth: strokeWidth,
          radius: radius,
          dash: dash,
          gap: gap,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
          ),
          padding: padding,
          child: this,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dash;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dash,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final len = dash.clamp(0, metric.length - distance);
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color ||
          old.strokeWidth != strokeWidth ||
          old.radius != radius ||
          old.dash != dash ||
          old.gap != gap;
}