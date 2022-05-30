/*
 * Summary: 仪表盘进度条组件
 * Created Date: 2022-05-30 21:09:40
 * Author: Spicely
 * -----
 * Last Modified: 2022-05-30 23:01:31
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */
part of flutter_muka;

class DashboardProgress extends StatelessWidget {
  /// 半径
  final double height;

  final Color? strokeColor;

  final Color valueColor;

  final double strokeWidth;

  final Widget? child;

  final double value;

  const DashboardProgress({
    Key? key,
    required this.value,
    required this.height,
    this.valueColor = Colors.white,
    this.strokeColor,
    this.strokeWidth = 4,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, height),
          painter: DashBoardPainter(
            value: this.value,
            valueColor: valueColor,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
          ),
        ),
        if (child != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: child!,
          )
      ],
    );
  }
}

class DashBoardPainter extends CustomPainter {
  /// 画笔颜色
  final Color? strokeColor;

  /// 画笔颜色
  final Color valueColor;

  final double strokeWidth;

  final double angle = 24;

  final double rad = pi / 180.0;

  final double value;

  DashBoardPainter({
    this.strokeColor,
    required this.strokeWidth,
    required this.value,
    required this.valueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height * 0.5 - strokeWidth;
    Offset center = Offset(size.width * 0.5, size.height * 0.5);
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    List.generate(31, (index) {
      if (value > index * 3.3) {
        paint.color = valueColor;
      } else {
        paint.color = strokeColor ?? valueColor.withOpacity(0.3);
      }
      canvas.save();
      canvas.translate(center.dx, center.dy + 10);
      canvas.rotate(index * -6.12 - 0.85);
      canvas.drawLine(
        Offset(-radius, 0),
        Offset(-radius + 5, 0),
        paint,
      );
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(DashBoardPainter oldDelegate) => value != oldDelegate.value ? true : false;
}
