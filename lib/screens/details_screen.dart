import 'dart:async';
import 'package:TractorMonitoring/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TractorMonitoring/screens/analysis.dart';
import 'package:TractorMonitoring/screens/history.dart';

import 'featuerd_screen.dart';

class DetailsScreen extends StatefulWidget {

  String title;
  String unit;
  bool isLoading;
  List<Parameters> paramList;

  DetailsScreen({
    Key? key,
    required this.title,
    required this.unit,
    required this.paramList,
    required this.isLoading,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(title, unit, paramList, isLoading);
}
class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedTag = 0;
  String title = "";
  String unit = "";
  bool isLoading = true;
  List<Parameters> specParamList = [];


  _DetailsScreenState(this.title, this.unit, this.specParamList, this.isLoading);

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      // this.specParamList.clear();
      setState(() {
        this.specParamList = _getDataFromMySQL();

      });

    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }


  List<Parameters> _getDataFromMySQL()  {
    List<Parameters> tempParamList = [];

    switch (widget.title) {
      case "Temperatura apa" :
        print("TEMPERATURA APA");
        // specParamList.clear();
        for (var parameters in widget.paramList) {
          print(parameters.temp_apa);
          tempParamList.add(Parameters(log_time: parameters.log_time,
              temp_apa: parameters.temp_apa));
        }

        break;
      case "Nivel apa" :
        print("NIVEL APA");
        for (var parameters in widget.paramList) {
          print(parameters.nivel_apa);
          tempParamList.add(Parameters(log_time: parameters.log_time,
              nivel_apa: parameters.nivel_apa));
        }

        break;
      case "Presiune ulei" :
        print("PRESIUNE ULEI");
        specParamList.clear();
        for (var parameters in widget.paramList) {
          tempParamList.add(Parameters(log_time: parameters.log_time,
              presiune_ulei: parameters.presiune_ulei));
        }

        break;
      case "Nivel combustibil" :
        print("NIVEL COMBUSTIBIL");
        // specParamList.clear();
        for (var parameters in widget.paramList) {
          tempParamList.add(Parameters(log_time: parameters.log_time,
              niv_combustibil: parameters.niv_combustibil));
        }

        break;
      default :
        print("EROARE SELECTARE CATEGORIE");
        break;
    }
    // specParamList.sublist(specParamList.length - 50, specParamList.length);
    print("LAAAAAAAAAAAA");
    print(specParamList.length);
    setState(() {
      isLoading = false;
    });

    return tempParamList;
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayMedium,
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

                _selectedTag == 0 && !isLoading ? Analysis(
                  paramList: specParamList, unit: widget.unit,) : (_selectedTag ==
                    0 || _selectedTag == 1) && isLoading
                    ? _buildLoadingIndicator()
                    : _selectedTag == 1 && !isLoading
                    ? History(paramList: specParamList, unit: widget.unit,)
                    : _buildLoadingIndicator(),
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
  final List<String> _tags = ["Analiză", "Istoric"];

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

