import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'details_screen.dart';

class Analysis extends StatefulWidget {
  List<Parameters> paramList;
  String unit;

  Analysis({Key? key,
    required this.paramList,
    required this.unit
  }) : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
          child: Center(
              child: Expanded(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Analiza în timp",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: _buildChart(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
      );
  }

//
//   Widget _buildChart() {
//     var series = [
//       charts.Series(
//           id: 'Parameters',
//           data: widget.paramList,
//           domainFn: (Parameters parameters, _) => parameters.log_time,
//           measureFn: (Parameters parameters, _) => parameters.temp_apa,
//           colorFn: (Parameters parameters, _) =>
//           charts.MaterialPalette.blue.shadeDefault
//       ),
//     ];
//
//     return charts.LineChart(
//       series,
//       animate: true,
//     );
//   }
// }

  Widget _buildChart() {
    var series = [
      charts.Series(
          id: 'Parameters',
          data: widget.paramList,
          domainFn: (Parameters parameters, _) =>
              DateTime.parse(parameters.log_time),
          measureFn: (Parameters parameters, _) => parameters.temp_apa,
          colorFn: (Parameters parameters, _) =>
          charts.MaterialPalette.blue.shadeDefault
      ),
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      behaviors: [
        new charts.ChartTitle('',
            titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification: charts.OutsideJustification.start)
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}


