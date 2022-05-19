import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';


class MakePaymentPage extends StatefulWidget {
  final int collectionId;

  const MakePaymentPage({this.collectionId});

  @override
  MakePaymentPageState createState() => MakePaymentPageState();
}

class MakePaymentPageState extends State<MakePaymentPage> {
  SupplierListViewModel modelSupplier;
  PaymentMethodViewModel modelPayment;
  CollectionDetailViewModel modelCollection;
  BankListViewModel modelBankList;

  int groupValue = 0;
  int groupValue1 = 0;
  int groupValue2 = 0;

  final TextEditingController remark = TextEditingController();
  bool userNameValidate = false;
  bool isUserNameValidate = false;

  var switch1 = true;
  File asset;

  String formattedDate;
  var date;

  var selectSupplier;
  var selectPaymentMode;
  var selectBank;
  var collectionAmount;
  var onAccountAmount;
  var invoiceId;
  var invoiceAmount;

  List strings1 = ['1478x', '1234x '];

  // ignore: deprecated_member_use
  List<File> imageList = List();
  // ignore: deprecated_member_use
  List<String> imageUrl = List();

  DateTime selectedDate = DateTime.now();

  var customFormat = DateFormat('dd-MM-yyyy');

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        isUserNameValidate = true;
      });
      return false;
    }
    setState(() {
      isUserNameValidate = false;
    });
    return true;
  }

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  selectImage() async {
    List<Asset> assets =
        await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    if (assets != null && assets.isNotEmpty) {
      assets.forEach((asset) async {
        final image = await Utils.compressAndGetFile(
          await Utils.byteDataToFile(await asset.getByteData()),
        );

        imageList.add(image);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements
    modelSupplier ?? (modelSupplier = SupplierListViewModel(this));
    // ignore: unnecessary_statements
    modelBankList ?? (modelBankList = BankListViewModel(this));
    // ignore: unnecessary_statements
    modelPayment ?? (modelPayment = PaymentMethodViewModel(this));
    // ignore: unnecessary_statements
    modelCollection ?? (modelCollection = CollectionDetailViewModel(this));
    print("Current page --> $runtimeType");
    final themeColor = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            Strings.makePayment,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                Get.back();
              }),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    bottom: 12,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await showPicker(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.Date,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              '${customFormat.format(selectedDate)}',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.date_range,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await supplierListDialog(
                        context,
                        themeColor,
                      );
                      selectSupplier = modelSupplier
                          .supplier.companySupplier[groupValue].supId;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.supplier,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              groupValue != null &&
                                      modelSupplier.supplier != null &&
                                      modelSupplier
                                          .supplier.companySupplier.isNotEmpty
                                  ? modelSupplier.supplier
                                      .companySupplier[groupValue].supName
                                  : Strings.selectsupplier,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Colors.grey.withOpacity(0.1),
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Strings.totaloutstand,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "4,54,000",
                          style: GoogleFonts.poppins(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.onaccount,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            modelCollection.collectionDetail != null &&
                                    modelCollection.collectionDetail
                                        .collectionDetails.isNotEmpty
                                ? modelCollection.collectionDetail
                                    ?.collectionDetails[0].onAccount
                                    .toString()
                                : "00000",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: themeColor.getColor(),
                          value: switch1,
                          onChanged: (bool value) {
                            setState(() {
                              switch1 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.accountcoll,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            modelCollection.collectionDetail != null &&
                                    modelCollection.collectionDetail
                                        .collectionDetails.isNotEmpty
                                ? modelCollection.collectionDetail
                                    .collectionDetails[0].collAmount
                                    .toString()
                                : "00000",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await paymentMethodListDialog(context, themeColor);
                      selectPaymentMode = modelPayment.paymentMethod
                          ?.outwardPaymentMethod[groupValue1].paymentModeTypeId
                          .toString();
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.paymentmode,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              groupValue1 != null &&
                                      modelPayment.paymentMethod != null &&
                                      modelPayment.paymentMethod
                                          .outwardPaymentMethod.isNotEmpty
                                  ? modelPayment
                                      .paymentMethod
                                      .outwardPaymentMethod[groupValue1]
                                      .paymentModeTypeName
                                  : Strings.selectpaymentmethod,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.checknumber,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '-',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await bankListDialog(context, themeColor);
                      selectBank = modelBankList
                          .bankList.outwardBanklist[groupValue2].bankId
                          .toString();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.bankdetails,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              groupValue2 != null &&
                                      modelBankList.bankList?.outwardBanklist !=
                                          null &&
                                      modelBankList
                                          .bankList.outwardBanklist.isNotEmpty
                                  ? '${modelBankList.bankList.outwardBanklist[groupValue2].bankName} - ' +
                                      ' ${modelBankList.bankList.outwardBanklist[groupValue2].accountNumber}'
                                  : Strings.selectbank,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Colors.grey.withOpacity(0.1),
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Strings.invoicedetails,
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.againstinvoice,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Row(
                            children: [
                              modelCollection.collectionDetail != null &&
                                      modelCollection.collectionDetail
                                          .invoiceDetails.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        "${modelCollection.collectionDetail.invoiceDetails[0].invoiceId}  x",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: Text(
                                        " - ",
                                        style:
                                            GoogleFonts.poppins(fontSize: 20),
                                      ),
                                    ),
                              SizedBox(width: 5),
                            ],
                          )
                        ],
                      ),
                      // Icon(
                      //   Icons.arrow_forward_ios_sharp,
                      //   color: Colors.black.withOpacity(0.5),
                      // ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.invoicetotal,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            modelCollection.collectionDetail != null &&
                                    modelCollection.collectionDetail
                                        .invoiceDetails.isNotEmpty
                                ? modelCollection.collectionDetail
                                    .invoiceDetails[0].totalAmount
                                    .toString()
                                : "00000",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Colors.grey.withOpacity(0.1),
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          Strings.yousaved,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          "4,000",
                          style: GoogleFonts.poppins(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.balanceamt,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '1,70,000',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 12,
                    bottom: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.paymentremark,
                              style: GoogleFonts.poppins(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 2,
                              controller: remark,
                              decoration: InputDecoration(
                                  errorText: isUserNameValidate
                                      ? Strings.enterremark
                                      : null),
                              keyboardType: TextInputType.multiline,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.arrow_forward_ios_sharp,
                      //   color: Colors.black.withOpacity(0.5),
                      // ),
                    ],
                  ),
                ),
                Container(
                  height: Get.height * 0.6,
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Colors.grey.withOpacity(0.1),
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          Strings.attachment,
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Divider(thickness: 1),
                      InkWell(
                        onTap: () async {
                          imageList.clear();
                          imageUrl.clear();
                          await selectImage();
                          // selectImage();
                          setState(() {});
                          // pickImages();
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            // color: Colors.pink
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: Colors.grey),
                              Text(
                                Strings.addnewreceipt,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                Strings.takephoto,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(
                            imageList.length,
                            (index) {
                              File asset = imageList[index];
                              setState(() {});
                              print(asset);
                              return Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 10,
                                        bottom: 10,
                                        right: 10,
                                        top: 5,
                                      ),
                                      // padding: EdgeInsets.only(top: 5,right: 5),
                                      child: Image.file(
                                        asset,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.red,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            imageList.removeAt(index);
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.topRight,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          validateTextField(remark.text) == true
                              ? {
                                  // Loader().showLoader(context),
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: Get.height,
                                        width: Get.width,
                                        color: Colors.transparent,
                                      ),
                                      Center(
                                        child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                                  if (selectSupplier == null)
                                    {
                                      selectSupplier = modelSupplier
                                          .supplier.companySupplier.first.supId,
                                    },
                                  if (selectPaymentMode == null)
                                    {
                                      selectPaymentMode = modelPayment
                                          .paymentMethod
                                          .outwardPaymentMethod
                                          .first
                                          .paymentModeTypeId,
                                    },
                                  if (selectBank == null)
                                    {
                                      selectBank = modelBankList.bankList
                                          .outwardBanklist.first.bankId,
                                    },
                                  onAccountAmount = modelCollection
                                      .collectionDetail
                                      .collectionDetails[0]
                                      .onAccount
                                      .toString(),
                                  collectionAmount = modelCollection
                                      .collectionDetail
                                      .collectionDetails[0]
                                      .onAccount
                                      .toString(),
                                  invoiceId = modelCollection.collectionDetail
                                      .invoiceDetails[0].invoiceId
                                      .toString(),
                                  invoiceAmount = modelCollection
                                      .collectionDetail
                                      .invoiceDetails[0]
                                      .collectedAmount
                                      .toString(),
                                  await uploadDocumentWithParamToServer(),
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode()),
                                  await serveRegisterRequestWith(),
                                }
                              : SizedBox();
                        },
                        child: modelSupplier
                                        .supplier?.companySupplier?.length ==
                                    null &&
                                modelBankList
                                        .bankList?.outwardBanklist?.length ==
                                    null &&
                                modelPayment.paymentMethod?.outwardPaymentMethod
                                        ?.length ==
                                    null &&
                                modelCollection.collectionDetail
                                        ?.collectionDetails?.length ==
                                    null
                            ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
                            : Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  alignment: Alignment.bottomCenter,
                                  height: Get.height / 18,
                                  width: Get.width * 0.8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.0),
                                      topRight: Radius.circular(22.0),
                                      bottomLeft: Radius.zero,
                                      bottomRight: Radius.zero,
                                    ),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      Strings.Submit,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  supplierListDialog(BuildContext context, themeColor) async {
    return modelSupplier.supplier.companySupplier.length == null
        ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
        : await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, dialogState) {
                  return AlertDialog(
                    title: Text(
                      Strings.selectsupplier,
                      style: GoogleFonts.poppins(),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        modelSupplier.supplier.companySupplier.length,
                        (int i) => Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: groupValue,
                              onChanged: (index) {
                                groupValue = index;
                                dialogState(() {});
                              },
                            ),
                            Text(
                              modelSupplier.supplier.companySupplier[i].supName,
                              style: GoogleFonts.poppins(),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: new Text(
                          Strings.Submit,
                          style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () async {
                          Get.back();
                        },
                      )
                    ],
                  );
                },
              );
            });
  }

  paymentMethodListDialog(BuildContext context, themeColor) async {
    return modelPayment.paymentMethod?.outwardPaymentMethod?.length == null
        ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
        : await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, dialogState) {
                  return AlertDialog(
                    title: Text(
                      Strings.selectpaymentmethod,
                      style: GoogleFonts.poppins(),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        modelPayment.paymentMethod.outwardPaymentMethod.length,
                        (int i) => Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: groupValue1,
                              onChanged: (index) {
                                groupValue1 = index;
                                dialogState(() {});
                              },
                            ),
                            Text(
                              modelPayment.paymentMethod.outwardPaymentMethod[i]
                                  .paymentModeTypeName,
                              style: GoogleFonts.poppins(),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: new Text(
                          Strings.Submit,
                          style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
  }

  bankListDialog(BuildContext context, themeColor) async {
    return modelBankList.bankList.outwardBanklist.length == null
        ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(themeColor.getColor())))
        : await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, dialogState) {
                  return AlertDialog(
                    title: Text(
                      Strings.selectbank,
                      style: GoogleFonts.poppins(),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(
                        modelBankList.bankList.outwardBanklist.length,
                        (int i) => Row(
                          children: [
                            Radio<int>(
                              value: i,
                              groupValue: groupValue2,
                              onChanged: (index) {
                                groupValue2 = index;
                                dialogState(() {});
                              },
                            ),
                            Text(
                              '${modelBankList.bankList.outwardBanklist[groupValue2].bankName} - ' +
                                  ' ${modelBankList.bankList.outwardBanklist[groupValue2].accountNumber}',
                              style: GoogleFonts.poppins(),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new TextButton(
                        child: new Text(
                          Strings.Submit,
                          style: GoogleFonts.poppins(
                            color: themeColor.getColor(),
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
  }

  uploadDocumentWithParamToServer() async {
    FocusScope.of(context).requestFocus(FocusNode());
    for (int i = 0; i < imageList.length; i++) {
      var request =
          http.MultipartRequest("POST", Uri.parse(Base_URL + uploadImage));
      request.fields["type"] = "collection_image";
      request.fields["logged_in_userid"] = loggedInUserId.toString();
      request.fields["comp_id"] = company_id.toString();

      var pic = await http.MultipartFile.fromPath("file", imageList[i].path);

      request.files.add(pic);
      request.headers['Authorization'] = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'token');
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var responseDict = jsonDecode(responseString);
        print(responseDict);
        if (responseDict['status'] == true) {
          imageUrl.add(responseDict["token"]);
        } else {
          print("failed");
        }
      }
    }
  }

  serveRegisterRequestWith() async {
    Map<String, dynamic> bodyData = {
      "collection_id": "new",
      "comp_id": company_id.toString(),
      "org_id": "0",
      "logged_in_userid": loggedInUserId.toString(),
      "date": selectedDate.toString(),
      "sup_id": selectSupplier.toString(),
      "on_account": onAccountAmount.toString(),
      "coll_amount": collectionAmount.toString(),
      "invoices": [
        {
          "invoice_id": invoiceId.toString(),
          "collected_amount": invoiceAmount.toString()
        }
      ],
      "collection_image_token": [],
      "payment_mode_type_id": selectPaymentMode.toString(),
      "ref_no": "1",
      "bank_id": selectBank.toString(),
      "remark": remark.text.toString(),
      "payment_status": "unpaid"
    };

    var url = Base_URL + insertcollection;
    http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': LoginModelClass.loginModelObj
              .getValueForKeyFromLoginResponse(key: 'token')
        },
        body: jsonEncode(bodyData));
    print('The error encountered here1 ${response.statusCode}');
    print(response.body);
    Loader().hideLoader(context);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseDict = jsonDecode(response.body);
      if (jsonDecode(response.body)['status'].toString() == 'true') {
        ToastUtils.showSuccess(message: responseDict['message'].toString());
        Get.back();
      } else {
        print('The error encountered here');
        imageUrl.clear();
        imageList.clear();
        print(responseDict);
        ToastUtils.showError(
          message: responseDict['message']?.toString() ??
              Strings.PleaseCheckForAllMandatoryFields,
        );
      }
    } else {
      Map responseDict = jsonDecode(response.body);
      String message = responseDict.values.toString().replaceAll('[', "");
      message = message.replaceAll(']', "");
      message = message.replaceAll('(', "");
      message = message.replaceAll(')', "");
      message = message.replaceAll('.,', ".\n");
      ToastUtils.showError(
        message: message != null && message.length > 0
            ? message
            : Strings.somethingWentWrong,
      );
    }
  }
}
