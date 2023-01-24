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
          ],
        )
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(title:widget.category.name, unit: widget.category.unit,)
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
              // ElevatedButton(
              //   child: Text(
              //     "Test",
              //     textScaleFactor: 1.5,
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     primary: Colors.white,
              //     onPrimary: Colors.black,
              //     elevation: 5,
              //     shadowColor: Colors.black,
              //   ),
              //   onPressed: () {
              //     // waterTemp();
              //   },
              // ),
            ],
          ),

        ],
      ),
    );
  }
}
