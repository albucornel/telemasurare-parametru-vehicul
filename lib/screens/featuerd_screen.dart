import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:TractorMonitoring/constants/size.dart';
import 'package:TractorMonitoring/models/category.dart';
import 'package:TractorMonitoring/screens/details_screen.dart';
import 'package:TractorMonitoring/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/ParametersService.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  _FeaturedScreenState createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen> {

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body:
         Column(
            children: <Widget>[
              AppBar(),
              Expanded(child:Body())

          ],
       ),
     )
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  Future<void> _deleteData() async {
    var url = 'https://telemasurare1.000webhostapp.com/deleteData.php';
    await http.post(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // wrap with a scrollable widget
        child: Column(
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Parametri",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            GridView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 24,
              ),
              itemBuilder: (context, index) {
                return
                     CategoryCard(
                       category: categoryList[index],
                );
              },
              itemCount: categoryList.length,
            ),
              ElevatedButton(
                child: Text(
                  "Reset",
                  textScaleFactor: 1.5,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sunteți sigur că vreți să resetați datele?", style: TextStyle(color: Colors.black),),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              elevation: 5,
                              shadowColor: Colors.black,
                            ),
                            child: Text("Da", style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              _deleteData();
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 65,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              elevation: 5,
                              shadowColor: Colors.black,
                            ),
                            child: Text("Nu", style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 20,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],

        )
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;
  CategoryCard({
    Key? key,
    required this.category,

  }) : super(key: key);
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  bool isLoading = true;
  List<Parameters> paramList =[];
  late Timer _timer;
  final int maxDataPoints = 10;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _getDataFromMySQL();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<List<Parameters>> _getDataFromMySQL() async {
    var url = 'https://telemasurare1.000webhostapp.com/getData.php';
    var response =await http.post(Uri.parse(url));
    var jsonData = json.decode(response.body);
    this.paramList.clear();

    for (var parameters in jsonData) {
      paramList.add(Parameters(log_time: parameters['log_time'],
          temp_apa: double.parse(parameters['temp_apa']),
          nivel_apa: double.parse(parameters['nivel_apa']),
          niv_combustibil: double.parse(parameters['niv_combustibil']),
          presiune_ulei: double.parse(parameters['presiune_ulei'])
      ));
    }
    setState(() {
      isLoading = false;
    });
    return paramList;
  }
  Widget _buildLoadingIndicator() {
    return Container(
      alignment: Alignment.center,
      width: 10,
      height: 10,
      // padding: EdgeInsets.only(top: 200),
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading? GestureDetector(

      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(title:widget.category.name, unit: widget.category.unit, paramList: paramList, isLoading: isLoading)
        ),
      ),
        child:  Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 4.0,
                spreadRadius: .05,
              ), //BoxShadow
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  widget.category.thumbnail,
                  height: kCategoryCardImageSize,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.category.name),
            ],

          ),

        ),
    ) : GestureDetector(

      child:  Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ), //BoxShadow
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                widget.category.thumbnail,
                height: kCategoryCardImageSize,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            _buildLoadingIndicator(),
            Text(widget.category.name),

        ],
        ),
      ),
    );

  }
}

class AppBar extends StatelessWidget {
  const AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            Color(0xff64C377),
            Color(0xff50B264),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Telemasurare\nparametri vehicul",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

        ],
      ),
    );
  }
}
class Parameters {
  int id;
  double temp_apa;
  double nivel_apa;
  double presiune_ulei;
  double niv_combustibil;
  String log_time;


  Parameters({
    this.id = 0,
    this.temp_apa = 0,
    this.nivel_apa = 0,
    this.presiune_ulei = 0,
    this.niv_combustibil = 0,
    this.log_time = "no time",

  });
  factory Parameters.fromJson(Map<String, dynamic> json) {
    return Parameters(
      id: json['id'],
      temp_apa: json['temp_apa'],
      nivel_apa: json['nivel_apa'],
      presiune_ulei: json['presiune_ulei'],
      niv_combustibil: json['niv_combustibil'],
      log_time: json['log_time'],
    );
  }
}