import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ReceiveOrder extends StatefulWidget {
  @override
  ReceiveOrderState createState() => ReceiveOrderState();
}

class ReceiveOrderState extends State<ReceiveOrder> {
  ReceiveOrderViewModel model;

  ScrollController controller;
  bool isPaging = false;
  int initPosition = 0;
  int page = 1;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      if (model.canPaging && !isPaging) {
        setState(() {
          isPaging = true;
        });
        page++;
        model.getReceiveOrderApi(page);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    // ignore: unnecessary_statements
    model ?? (model = ReceiveOrderViewModel(this));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          Strings.receivedord,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: model.receiveOrder == null
          ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
          : Container(
              child: model.receiveOrder.orders != null &&
                      model.receiveOrder.orders.isNotEmpty
                  ? ListView.builder(
                      controller: controller,
                      itemCount: model.receiveOrder.orders?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return orderTile(index);
                      },
                    )
                  : Container(
                      height: Get.height * 0.8,
                      child: Center(
                        child: Text(
                          Strings.ordernotfound,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }

  orderTile(int index) {
    return Container(
      child: InkWell(
        onTap: () async {
          var data = await Get.to(() => ReceivedOrderPage(
              productId: model.receiveOrder.orders[index].ordId));
          await model.getReceiveOrderApiInitial();
        },
        child: Container(
          margin: EdgeInsets.only(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 5.0,
                spreadRadius: 1,
                offset: Offset(0.0, 1),
              ),
            ],
          ),
          width: Get.width,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/productPlaceaHolderImage.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 160,
                        padding: EdgeInsets.all(10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AutoSizeText(
                            '${Strings.orderid} : ${model.receiveOrder.orders[index].ordId}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            minFontSize: 11,
                          ),
                          SizedBox(height: 2),
                          AutoSizeText(
                            '${Strings.OrderDate} : ${model.receiveOrder.orders[index].createdAt.toString().split(' ').first} ',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            minFontSize: 11,
                          ),
                          SizedBox(height: 2),
                          AutoSizeText(
                            '${Strings.orderitems} : ${model.receiveOrder.orders[index].productCount ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF5D6A78),
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            minFontSize: 11,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "${Strings.total} : ${model.receiveOrder.orders[index].amount.floor()}",
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        blurRadius: 6.0,
                                        spreadRadius: 0.0,
                                        offset: Offset(0.0, 1.0),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        model.receiveOrder.orders[index]
                                                        .status !=
                                                    null &&
                                                model.receiveOrder.orders[index]
                                                    .status.isNotEmpty
                                            ? model.receiveOrder.orders[index]
                                                .status
                                            : Strings.na,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF5D6A78),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        FontAwesome5.dot_circle,
                                        size: 12,
                                        color: Colors.blue,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
