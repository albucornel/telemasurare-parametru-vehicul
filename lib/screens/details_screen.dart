import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:TractorMonitoring/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TractorMonitoring/screens/analysis.dart';
import 'package:TractorMonitoring/screens/history.dart';

import '../service/ParametersService.dart';

class DetailsScreen extends StatefulWidget {
  String title;
  String unit;
  DetailsScreen({
    Key? key,
    required this.title,
    required this.unit
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(title, unit);
}



class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedTag = 0;
  String title;
  String unit;
  bool _isLoading = true;
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
  _DetailsScreenState(this.title,this.unit);
  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  Future<List<Parameters>> _getDataFromMySQL() async {
    var url = 'https://telemasurare1.000webhostapp.com/getData.php';
    var response =await http.post(Uri.parse(url));
    var jsonData = json.decode(response.body);
    this.paramList.clear();

    switch(widget.title) {
      case "Temperatura apa" :
        for (var parameters in jsonData) {
          paramList.add(Parameters(log_time: parameters['log_time'],
              temp_apa: double.parse(parameters['temp_apa'])));
        }
        break;
      case "Nivel apa" :
        for (var parameters in jsonData) {
          paramList.add(Parameters(log_time: parameters['log_time'],
              temp_apa: double.parse(parameters['nivel_apa'])));
        }
        break;
      case "Presiune ulei" :
        for (var parameters in jsonData) {
          paramList.add(Parameters(log_time: parameters['log_time'],
              temp_apa: double.parse(parameters['presiune_ulei'])));
        }
        break;
      case "Nivel combustibil" :
        for (var parameters in jsonData) {
          paramList.add(Parameters(log_time: parameters['log_time'],
              temp_apa: double.parse(parameters['niv_combustibil'])));
        }
        break;
       default :
         print("EROARE SELECTARE CATEGORIE");
        break;
  }
    paramList.sublist(paramList.length-20, paramList.length);
    print(paramList);
    setState(() {
      _isLoading = false;
    });

    return paramList;
  }
  Widget _buildLoadingIndicator() {
    return Container(
        alignment: Alignment.center,
      padding: EdgeInsets.only(top: 200),
      child: CircularProgressIndicator(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Stack(
                    children: [
                      Align(
                        child: Text(
                          this.title,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: CustomIconButton(
                          child: const Icon(Icons.arrow_back),
                          height: 35,
                          width: 35,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),

                const SizedBox(
                  height:
                  13,
                ),

                const SizedBox(
                  height: 15,
                ),
                CustomTabView(
                  index: _selectedTag,
                  changeTab: changeTab,
                ),

                  _selectedTag == 0 && !_isLoading ? Analysis(paramList: paramList, unit: widget.unit,) : (_selectedTag == 0 || _selectedTag == 1) && _isLoading ? _buildLoadingIndicator() : _selectedTag == 1 && !_isLoading ? History(paramList: paramList, unit: widget.unit,) : _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;
  const CustomTabView({Key? key, required this.changeTab, required this.index})
      : super(key: key);

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["Analiza", "Istoric"];

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .13, vertical: 15),
        decoration: BoxDecoration(
          color: widget.index == index ? kPrimaryColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
            color: widget.index != index ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color? color;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Center(child: child),
        onTap: onTap,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 2.0,
            spreadRadius: .05,
          ), //BoxShadow
        ],
      ),
    );
  }
}
class Parameters {
  int id;
  double temp_apa;
  double nivel_apa;
  double presiune_ilei;
  double niv_combustibil;
  String log_time;


  Parameters({
     this.id = 0,
     this.temp_apa = 0,
     this.nivel_apa = 0,
     this.presiune_ilei = 0,
     this.niv_combustibil = 0,
     this.log_time = "no time",

  });
  factory Parameters.fromJson(Map<String, dynamic> json) {
    return Parameters(
      id: json['id'],
      temp_apa: json['temp_apa'],
      nivel_apa: json['nivel_apa'],
      presiune_ilei: json['presiune_ilei'],
      niv_combustibil: json['niv_combustibil'],
      log_time: json['log_time'],
    );
  }
}