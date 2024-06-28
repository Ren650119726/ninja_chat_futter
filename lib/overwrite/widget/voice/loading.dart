import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'indictor.dart';

class Loading extends StatefulWidget {
  Indicator indicator;
  double size;
  Color color;

  Loading({required this.indicator, this.size = 50.0, this.color = Colors.white}) {
    this.indicator = indicator;
  }

  @override
  State<StatefulWidget> createState() {
    return LoadingState(indicator, size);
  }
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
  Indicator indicator;
  double size;

  LoadingState(this.indicator, this.size);

  @override
  void initState() {
    super.initState();
    indicator.context = this;
    indicator.start();
  }

  @override
  void dispose() {
    indicator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(indicator: indicator, color: widget.color),
      size: Size.square(size),
    );
  }
}

class _Painter extends CustomPainter {
  Indicator indicator;
  Color color;
  late Paint defaultPaint; // 非空实例变量，在构造函数中初始化

  _Painter({required this.indicator, required this.color}) : super() {
    defaultPaint = Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..color = color
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    indicator.paint(canvas, defaultPaint, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
