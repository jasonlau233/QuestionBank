library flutter_radar_chart;

import 'dart:math' as math;
import 'dart:math' show pi, cos, sin;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

const defaultGraphColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
];

typedef void OnItemClickListen(int featureIndex);
typedef void OnItemClickListen2(int featureIndex);

class RadarChart extends StatefulWidget {
  final List<int> ticks;
  final List<String> features;
  final List<String> featuresReal;
  final List<List<int>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle selectedFeaturesTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final OnItemClickListen onItemClickListen;

  ///被选中的feature
  final int selectedFeature;

  const RadarChart(
      {Key key,
      @required this.ticks,
      @required this.features,
      @required this.featuresReal,
      @required this.data,
      this.reverseAxis = false,
      this.ticksTextStyle = const TextStyle(color: Colors.grey, fontSize: 12),
      this.selectedFeaturesTextStyle =
          const TextStyle(color: Colors.grey, fontSize: 12),
      this.featuresTextStyle =
          const TextStyle(color: Colors.black, fontSize: 16),
      this.outlineColor = Colors.black,
      this.axisColor = Colors.grey,
      this.graphColors = defaultGraphColors,
      this.sides = 0,
      this.onItemClickListen,
      this.selectedFeature = 0})
      : super(key: key);

  @override
  _RadarChartState createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart>
    with SingleTickerProviderStateMixin {
  double fraction = 0;
  Animation<double> animation;
  AnimationController animationController;
  int selectedFeatureHere;

  @override
  void initState() {
    super.initState();
    selectedFeatureHere = widget.selectedFeature;
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: animationController,
    ))
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    animationController.forward();
  }

  @override
  void didUpdateWidget(RadarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CanvasTouchDetector(
      builder: (context) {
        return CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: RadarChartPainter(
              context,
              widget.ticks,
              widget.features,
              widget.featuresReal,
              widget.data,
              widget.reverseAxis,
              widget.ticksTextStyle,
              widget.selectedFeaturesTextStyle,
              widget.featuresTextStyle,
              widget.outlineColor,
              widget.axisColor,
              widget.graphColors,
              widget.sides,
              this.fraction,
              widget.onItemClickListen, (index) {
            setState(() {
              selectedFeatureHere = index;
            });
          }, selectedFeatureHere),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class RadarChartPainter extends CustomPainter {
  final List<int> ticks;
  final List<String> features;
  final List<String> featuresReal;
  final List<List<int>> data;
  final bool reverseAxis;
  final TextStyle ticksTextStyle;
  final TextStyle selectedFeaturesTextStyle;
  final TextStyle featuresTextStyle;
  final Color outlineColor;
  final Color axisColor;
  final List<Color> graphColors;
  final int sides;
  final double fraction;
  final BuildContext context;
  final OnItemClickListen clickListen;
  final OnItemClickListen2 clickListen2;
  final int selectedFeature;

  RadarChartPainter(
      this.context,
      this.ticks,
      this.features,
      this.featuresReal,
      this.data,
      this.reverseAxis,
      this.ticksTextStyle,
      this.selectedFeaturesTextStyle,
      this.featuresTextStyle,
      this.outlineColor,
      this.axisColor,
      this.graphColors,
      this.sides,
      this.fraction,
      this.clickListen,
      this.clickListen2,
      this.selectedFeature);

  Path variablePath(Size size, double radius, int sides) {
    var path = Path();
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    if (sides < 3) {
      // Draw a circle
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));
    } else {
      // Draw a polygon
      Offset startPoint = Offset(radius * cos(-pi / 2), radius * sin(-pi / 2));

      path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

      for (int i = 1; i <= sides; i++) {
        double x = radius * cos(angle * i - pi / 2) + center.dx;
        double y = radius * sin(angle * i - pi / 2) + center.dy;
        path.lineTo(x, y);
      }
      path.close();
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);

    final centerX = size.width / 2.0;
    final centerY = size.height / 2.0;
    final centerOffset = Offset(centerX, centerY);
    final radius = math.min(centerX, centerY) * 0.8;
    final scale = radius / ticks.last;

    // Painting the chart outline
    var outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    var ticksPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;
    myCanvas.drawPath(variablePath(size, radius, this.sides), outlinePaint);
    // Painting the circles and labels for the given ticks (could be auto-generated)
    // The last tick is ignored, since it overlaps with the feature label
    var tickDistance = radius / (ticks.length);
    var tickLabels = reverseAxis ? ticks.reversed.toList() : ticks;

    // Painting the axis for each given feature
    var angle = (2 * pi) / features.length;

    for (int index = 0; index < features.length; index++) {
      {
        var xAngle = cos(angle * index - pi / 2);
        var yAngle = sin(angle * index - pi / 2);

        var featureOffset =
            Offset(centerX + radius * xAngle, centerY + radius * yAngle);

        var featureOffset2 = Offset(centerX + radius * 1.15 * xAngle - 10,
            centerY + radius * 1.2 * yAngle);

        myCanvas.drawLine(centerOffset, featureOffset, ticksPaint);

        var featureLabelFontHeight = featuresTextStyle.fontSize;
        var featureLabelFontWidth = featuresTextStyle.fontSize - 5;
        var labelYOffset = yAngle < 0 ? -featureLabelFontHeight : 0;
        var labelXOffset =
            xAngle < 0 ? -featureLabelFontWidth * features[index].length : 0;

        TextPainter(
          text: TextSpan(
              text: features[index],
              style: selectedFeature != index
                  ? featuresTextStyle
                  : selectedFeaturesTextStyle),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(
              canvas,
              Offset(featureOffset2.dx + labelXOffset,
                  featureOffset2.dy + labelYOffset));

        var paint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = Colors.transparent
          ..invertColors = false;

        var featureOffset3 = Offset(centerX + radius * 1.35 * xAngle - 10,
            centerY + radius * 1.15 * yAngle + 5);

        Rect rect = Rect.fromCenter(
            center: Offset(featureOffset3.dx + labelXOffset + 20,
                featureOffset3.dy + labelYOffset + 5),
            width: 60,
            height: 30);
        myCanvas.drawRect(rect, paint, onTapUp: (detail) {
          ///点击第几章
          onTapFeature(index);
        }, onTapDown: (detail) {
          ///点击第几章
          onTapFeature(index);
        });
      }
    }

    // Painting each graph
    data.asMap().forEach((index, graph) {
      double opacity = 0.5;
      var graphPaint = Paint()
        ..color = graphColors[index % graphColors.length].withOpacity(opacity)
        ..style = PaintingStyle.fill;

      /*var graphOutlinePaint = Paint()
        ..color = graphColors[index % graphColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..isAntiAlias = true;*/

      // Start the graph on the initial point
      var scaledPoint = scale * graph[0] * fraction;
      var path = Path();

      if (reverseAxis) {
        path.moveTo(centerX, centerY - (radius * fraction - scaledPoint));
      } else {
        path.moveTo(centerX, centerY - scaledPoint);
      }

      graph.asMap().forEach((index, point) {
        if (index == 0) return;

        var xAngle = cos(angle * index - pi / 2);
        var yAngle = sin(angle * index - pi / 2);
        var scaledPoint = scale * point * fraction;

        if (reverseAxis) {
          path.lineTo(centerX + (radius * fraction - scaledPoint) * xAngle,
              centerY + (radius * fraction - scaledPoint) * yAngle);
        } else {
          path.lineTo(
              centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);
        }
      });

      path.close();
      myCanvas.drawPath(path, graphPaint);
      //canvas.drawPath(path, graphOutlinePaint);

      if (reverseAxis) {
        TextPainter(
          text: TextSpan(text: tickLabels[0].toString(), style: ticksTextStyle),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(canvas, Offset(centerX, centerY - ticksTextStyle.fontSize));
      }

      tickLabels
          .sublist(reverseAxis ? 1 : 0,
              reverseAxis ? ticks.length : ticks.length - 1)
          .asMap()
          .forEach((index, tick) {
        var tickRadius = tickDistance * (index + 1);

        myCanvas.drawPath(
            variablePath(size, tickRadius, this.sides), ticksPaint);

        TextPainter(
          text: TextSpan(text: tick.toString(), style: ticksTextStyle),
          textDirection: TextDirection.ltr,
        )
          ..layout(minWidth: 0, maxWidth: size.width)
          ..paint(canvas,
              Offset(centerX, centerY - tickRadius - ticksTextStyle.fontSize));
      });
    });
  }

  void onTapFeature(int index) {
    print(features[index]);
    clickListen?.call(index);
    clickListen2?.call(index);
  }

  @override
  bool shouldRepaint(RadarChartPainter oldDelegate) {
    return true;
  }
}
