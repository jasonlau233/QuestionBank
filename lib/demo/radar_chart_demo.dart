import 'package:flutter/material.dart';
import 'package:question_bank/utils/color.dart';
import 'package:question_bank/widget/radar_chart.dart';

void main() => runApp(MyApp());

///
/// 能力表格图的demo
///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radar Chart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RadarChartPage(),
    );
  }
}

class RadarChartPage extends StatefulWidget {
  const RadarChartPage({Key key}) : super(key: key);

  @override
  _RadarChartPageState createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 3;

  @override
  Widget build(BuildContext context) {
    const ticks = [25, 50, 75, 100];
    var features = ["第一章", "第二章", "第三章", "第四章", "第五章", "第六章", "第七️章", "第八章"];
    var data = [
      [60, 60, 60, 60, 60, 60, 60, 60],
      [60, 80, 100, 40, 50, 75, 80, 30]
    ];

    features = features.sublist(0, numberOfFeatures.floor());
    data = data
        .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Radar Chart Example'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  darkMode
                      ? Text(
                          'Light mode',
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          'Dark mode',
                          style: TextStyle(color: Colors.black),
                        ),
                  Switch(
                    value: this.darkMode,
                    onChanged: (value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  useSides
                      ? Text(
                          'Polygon border',
                          style: darkMode
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: Colors.black),
                        )
                      : Text(
                          'Circular border',
                          style: darkMode
                              ? TextStyle(color: Colors.white)
                              : TextStyle(color: Colors.black),
                        ),
                  Switch(
                    value: this.useSides,
                    onChanged: (value) {
                      setState(() {
                        useSides = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Number of features',
                    style: TextStyle(
                        color: darkMode ? Colors.white : Colors.black),
                  ),
                  Expanded(
                    child: Slider(
                      value: this.numberOfFeatures,
                      min: 3,
                      max: 8,
                      divisions: 5,
                      onChanged: (value) {
                        setState(() {
                          numberOfFeatures = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: 230,
                height: 230,
                child: RadarChart(
                  ticks: ticks,
                  features: features,
                  data: data,
                  reverseAxis: false,
                  sides: useSides ? features.length : 0,
                  graphColors: [Color(0xffF9E9E8), ColorUtils.color_bg_theme],
                  outlineColor: Color(0xffAAECFF),
                  axisColor: Color(0xffAAECFF),
                  ticksTextStyle: TextStyle(
                      fontSize: 11, color: ColorUtils.color_text_theme),
                  featuresTextStyle: TextStyle(
                      fontSize: 12, color: ColorUtils.color_text_level1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
