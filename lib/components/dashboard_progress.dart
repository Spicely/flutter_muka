/*
 * Summary: 仪表盘进度条组件
 * Created Date: 2022-05-30 21:09:40
 * Author: Spicely
 * -----
 * Last Modified: 2022-05-30 22:32:23
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

  final Color color;

  final double strokeWidth;

  final Widget? child;

  const DashboardProgress({
    Key? key,
    required this.height,
    this.color = Colors.white,
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
            strokeColor: color,
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
  final Color strokeColor;

  final double strokeWidth;

  final double angle = 24;

  final double rad = pi / 180.0;

  DashBoardPainter({
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height * 0.5 - strokeWidth;
    final scale = radius / 75;
    Offset center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawColor(Colors.orange, BlendMode.srcIn);
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    List.generate(31, (index) {
      // if (index < 10) {
      //   paint.color = Colors.red;
      // } else {
      //   paint.color = Colors.white;
      // }
      canvas.save();
      canvas.translate(center.dx, center.dy - 20);
      canvas.rotate(index * -6.12 - 0.81);
      canvas.drawLine(
        Offset(-radius, 0),
        Offset(-radius + 5, 0),
        paint,
      );
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
