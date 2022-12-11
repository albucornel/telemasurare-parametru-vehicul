
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Histoty extends StatelessWidget {
  const Histoty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // wrap with a scrollable widget
      child: Column(
          children: <Widget>[

            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(0),
                        child: Table(
                          border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.grey, style: BorderStyle.solid)),
                          children: [
                            TableRow(children: [
                              Text('Value', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Data/Ora', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            TableRow(children: [
                              Text('0.644', textAlign: TextAlign.center),
                              Text('21/11/2022\n 15:53:00', textAlign: TextAlign.center),
                            ]),
                            TableRow(children: [
                              Text('0.644', textAlign: TextAlign.center),
                              Text('21/11/2022\n 15:53:00', textAlign: TextAlign.center),
                            ]), TableRow(children: [
                              Text('0.644', textAlign: TextAlign.center),
                              Text('21/11/2022\n 15:53:00', textAlign: TextAlign.center),
                            ]), TableRow(children: [
                              Text('0.644', textAlign: TextAlign.center),
                              Text('21/11/2022\n 15:53:00', textAlign: TextAlign.center),
                            ]),
                          ],
                        ),
                      ),
                    ])
            )
          ]
      ),
    );
  }
}
