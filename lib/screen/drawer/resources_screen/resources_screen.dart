import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  List name = ['FAQs', 'Video Tutorial', 'Product Video(s)'];
  List icons = [
    Icons.info,
    Icons.video_library_outlined,
    Icons.video_call_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Resources',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.0,
        // backgroundColor: themeColor.getColor(),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: Get.height / 5.5,
            width: Get.width,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: themeColor.getColor(),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
                bottomLeft: Radius.circular(22.0),
                bottomRight: Radius.circular(22.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How you can help you?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          gridViewWidget(),
        ],
      ),
    );
  }

  Widget gridViewWidget() {
    final themeColor = Provider.of<ThemeNotifier>(context);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 15),
      padding: EdgeInsets.only(left: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
        ),
        itemCount: name.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Nav.route(context, FAQSPages());
              }
              if (index == 1) {}
              if (index == 2) {}
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                // color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeColor.getColor(),
                    ),
                    child: Icon(
                      icons[index],
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Center(
                      child: Text(
                        name[index],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
