import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'details_screen.dart';


class History extends StatefulWidget {
  List<Parameters> paramList;
  String unit;

  History({Key? key,
    required this.paramList,
    required this.unit
  }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final StreamController<List<Parameters>> readingStreamController = StreamController<List<Parameters>>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (!readingStreamController.isClosed) {
      readingStreamController.sink.add(widget.paramList);
    }
  }

  @override
  void dispose() {
    readingStreamController.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Expanded(
            child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

                   child:
                   Center(
                    child: StreamBuilder<List<Parameters>>(
                      stream: readingStreamController.stream,
                      builder: (context, snapshot) {


                        if (!snapshot.hasData) return CircularProgressIndicator();
                        return Column(
                          children: [
                            DataTable(
                              columns: [
                                DataColumn(label: Text("Value (" + widget.unit + ")",style: TextStyle(fontWeight: FontWeight.bold)), numeric: true,),
                                DataColumn(label: Text("Data & Ora",style: TextStyle(fontWeight: FontWeight.bold)), numeric: false,),
                              ], rows: [],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return  DataTable(
                                    columns: [
                                      DataColumn(label: Text(""), numeric: false,),
                                      DataColumn(label: Text(""), numeric: true,),
                                    ],
                                    rows: [
                                      DataRow(
                                          cells: [
                                            DataCell(Text('${data.temp_apa}', textAlign: TextAlign.center, maxLines: 2,
                                              style: TextStyle(fontSize: 16),)),
                                            DataCell( Text('${data.log_time}', textAlign: TextAlign.center, maxLines: 2,softWrap: true,

                                              style: TextStyle(fontSize: 16),)),
                                          ]
                                      ),
                                    ],
                                  );
                                  // Text('${data.id}, ${data.temp_apa}°C');
                                },
                        )
                              )
                          ],
                        );

                      },
                    ),
                  ),
                ),
    ),
      ),
    );
  }
}


