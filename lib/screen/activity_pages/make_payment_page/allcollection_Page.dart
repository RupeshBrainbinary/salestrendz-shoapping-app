import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class AllCollectionPage extends StatefulWidget {
  @override
  AllCollectionPageState createState() => AllCollectionPageState();
}

class AllCollectionPageState extends State<AllCollectionPage> {
  AllCollectionListViewModel model;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    model ?? (model = AllCollectionListViewModel(this));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Strings.allcollections, style: GoogleFonts.poppins()),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: model.allCollection.collection.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: InkWell(
                onTap: () {
                  Nav.route(
                    context,
                    MakePaymentPage(
                      collectionId: model
                          .allCollection.collection.data[index].collectionId,
                    ),
                  );
                },
                child: Card(
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: Text(
                      model.allCollection.collection.data[index].collectionId
                          .toString(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
