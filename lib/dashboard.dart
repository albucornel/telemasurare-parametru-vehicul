import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Plantdata {
  String plantID;
  String plantType;
  String plantDimension;
  String plantDescription;

  Plantdata(
      {required this.plantID,
        required this.plantType,
        required this.plantDimension,
        required this.plantDescription});

  factory Plantdata.fromJson(Map<String, dynamic> json) {
    return Plantdata(
        plantID: json['id'],
        plantType: json['type'],
        plantDimension: json['dimension'],
        plantDescription: json['description']);
  }
}

class MyPlantsScreen extends StatefulWidget {
  late final String idHolder;

  MyPlantsScreen(this.idHolder);

  @override
  _MyPlantsState createState() => _MyPlantsState(this.idHolder);
}

class _MyPlantsState extends State<MyPlantsScreen> {
  final String getPlantURL =
      'https://plantmonitoringsystem5.000webhostapp.com/getMyPlant.php';
  final String getAllPlantsURL =
      'https://plantmonitoringsystem5.000webhostapp.com/get.php';

  final String idHolder;

  _MyPlantsState(this.idHolder);


  Future<List<Plantdata>> fetchAllPlants() async {
    var data = {'id': int.parse(idHolder.toString())};

    var getPlantResponse =
    await http.post(Uri.parse(getAllPlantsURL), body: json.encode(data));
    if (getPlantResponse.statusCode == 200) {
      final items =
      json.decode(getPlantResponse.body).cast<Map<String, dynamic>>();

      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();
      print(plantList);
      setState(() {
        packageList = plantList;
        _selectedPackage = packageList[0];
      });
      return plantList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  late Plantdata _selectedPackage;
  late Future<List<Plantdata>> futurePlants;
  late Future<List<Plantdata>> futureAllPlants;

  List<Plantdata> packageList = [];

  @override
  void initState() {
    futurePlants = fetchAllPlants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plantdata>>(
      future: fetchAllPlants(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DropdownMenuItem<Plantdata>> items = packageList.map((item) {
            return DropdownMenuItem<Plantdata>(
              child: Text(item.plantType),
              value: item,
            );
          }).toList();

          // if list is empty, create a dummy item
          if (items.isEmpty) {
            items = [
              DropdownMenuItem(
                child: Text(_selectedPackage.plantType),
                value: _selectedPackage,
              )
            ];
          }
          return Scaffold(
            body: Container(
              constraints: BoxConstraints.expand(),

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          height: 80,
                          color: Colors.grey.withOpacity(0.12),
                          //margin: EdgeInsets.only(top: 80),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Spacer(),
                              Expanded(
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Planti ',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 45),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          )),
                    ],
                  ),
                  Positioned(
                    top: 110,
                    child: Container(
                      height: MediaQuery.of(context).size.height - 130,
                      width: MediaQuery.of(context).size.width - 30,
                      child: FutureBuilder<List<Plantdata>>(
                          future: futurePlants,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio:
                                    (MediaQuery.of(context).size.width <
                                        MediaQuery.of(context)
                                            .size
                                            .height)
                                        ? 0.75
                                        : 1.4,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    crossAxisCount: 2),
                                padding: EdgeInsets.only(top: 0.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    color: Colors.transparent,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: new BorderSide(
                                              color: Colors.blueGrey
                                                  .withOpacity(0.4),
                                              width: 1.0),
                                          borderRadius:
                                          BorderRadius.circular(4.0)),
                                      color:
                                      Colors.greenAccent.withOpacity(0.12),
                                      margin: EdgeInsets.only(bottom: 2.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            left: 0,
                                            right: 0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10.0),
                                                  child: SizedBox(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.35,
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .plantType,
                                                      maxLines: 3,
                                                      //'Note Title',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),

                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [

                                                  ],
                                                ),
                                              ],
                                            ),
                                            //SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data!.length == null
                                    ? 0
                                    : snapshot.data!.length,
                              );
                              // Text(snapshot.data.);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            // By default, show a loading spinner.
                            return Center(child: CircularProgressIndicator());
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

}
