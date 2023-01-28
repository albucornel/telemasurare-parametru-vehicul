import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'featuerd_screen.dart';

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
                            "Analiză în timp ( "+widget.unit+"/Data-Ora )",
                            // style: TextStyle(
                            //     fontWeight: FontWeight.bold
                            // ),
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

  Widget _buildChart() {
    var minValue = widget.paramList.map((e) =>  widget.unit=='°C'? (e.temp_apa).floor() : widget.unit=='Bar'? (e.presiune_ulei).floor() :widget.unit=='L'? (e.niv_combustibil).floor(): widget.unit=='l'? (e.nivel_apa).floor(): (e.temp_apa).floor()).reduce(min);
    var maxValue = widget.paramList.map((e) =>  widget.unit=='°C'? (e.temp_apa).ceil() : widget.unit=='Bar'? (e.presiune_ulei).ceil() :widget.unit=='L'? (e.niv_combustibil).ceil(): widget.unit=='l'? (e.nivel_apa).ceil() : (e.temp_apa).ceil()).reduce(max);
    var series = [
      charts.Series(
          id: 'Parameters',
          data: widget.paramList,
          domainFn: (Parameters parameters, _) =>
              DateTime.parse(parameters.log_time),
          measureFn: (Parameters parameters, _) => widget.unit=='°C'? parameters.temp_apa : widget.unit=='Bar'? parameters.presiune_ulei :widget.unit=='L'? parameters.niv_combustibil: widget.unit=='l'? parameters.nivel_apa : parameters.nivel_apa,
          colorFn: (Parameters parameters, _) =>
          charts.MaterialPalette.blue.shadeDefault
      ),
    ];

    return charts.TimeSeriesChart(
      series,
      animate: true,
      primaryMeasureAxis: NumericAxisSpec( viewport: NumericExtents(minValue, maxValue)),
      behaviors: [
        new charts.ChartTitle('',
            titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification: charts.OutsideJustification.start),
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

}