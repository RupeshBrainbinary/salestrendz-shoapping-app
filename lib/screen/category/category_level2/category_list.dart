import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  var currrentIndex;

  List data = [
    {'name': 'Mobile'},
    {'name': 'Electronic'},
    {'name': 'Beverages'},
    {'name': 'Shoes'},
    {'name': 'Shirt'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currrentIndex = data[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Container(
      color: Colors.grey[200],
      height: 60,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 8, right: 2),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  currrentIndex = data[index];
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 30,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Center(
                    child: Text(
                      data[index]['name'],
                      style: GoogleFonts.poppins(
                        color: currrentIndex == data[index]
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: currrentIndex == data[index]
                      ? Colors.grey[600]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
