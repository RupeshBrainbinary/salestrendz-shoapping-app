import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:validators/validators.dart' as validator;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

final LoginModelClass loginModelObject = LoginModelClass.loginModelObj;

class DropDownModel {
  DropDownModel({this.name, this.id});

  final String name;
  final int id;
}

class RegisterAsRetailer extends StatefulWidget {
  @override
  _RegisterAsRetailerState createState() => _RegisterAsRetailerState();
}

class _RegisterAsRetailerState extends State<RegisterAsRetailer> {
  List<DropDownModel> countriesList = [];
  List<DropDownModel> statesList = [];
  List<DropDownModel> cityList = [];

  String selectedCountry;
  String selectedState;
  String selectedCity;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController firmController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController selectAadharController = TextEditingController();
  TextEditingController selectPanController = TextEditingController();
  TextEditingController selectGstController = TextEditingController();

  String _adhharImage;
  String _panImage;
  String _gstImage;
  bool adhhar = false;
  bool pan = false;
  bool gst = false;
  bool country = false;
  bool state = false;
  bool city = false;
  Color isAdharSelected = HeaderColor;
  Color isPanSelected = HeaderColor;
  Color isGstSelected = HeaderColor;

  @override
  void initState() {
    super.initState();
    getCountriesList(1);
    selectedCountry = 'India';
    getStatesWithReferenceTo(context: context, countryID: '101', pageNumber: 1);
  }

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Container(
      child: SafeArea(
        child: WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            Get.back();
            loginModelObject.resetModel();
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AuthHeader(
                      headerTitle: Strings.registerAsARetailer,
                      headerBigTitle: Strings.New,
                      isLoginHeader: false,
                    ),
                    Form(
                        //autovalidate: true,
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              fullNameWidget(),
                              SizedBox(height: 10),
                              firmNameWidget(),
                              SizedBox(height: 10),
                              mobileNoWidget(),
                              SizedBox(height: 10),
                              emailWidget(),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  try {
                                    File file = await FilePicker.getFile(
                                        type: FileType.image);
                                    uploadDocumentWithParamToServer(
                                        documentType: 'adhar_card', file: file);
                                    selectAadharController.text =
                                        file.path.split('/').last;
                                    if (file != null) {
                                      isAdharSelected = Colors.green;
                                    }
                                    setState(() {});
                                    FocusScope.of(context).unfocus();
                                  } catch (e) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor: Theme.of(context).primaryColor,
                                        controller: selectAadharController,
                                        decoration: InputDecoration(
                                          enabled: false,
                                          filled: true,
                                          hintText: Strings.attachAdhaarCardDoc,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey[700],
                                          ),
                                          fillColor: HeaderColor,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15.0),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon:
                                              Icon(Icons.camera_alt_outlined),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_sharp,
                                      color: isAdharSelected,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              adhhar == true
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              Strings.selectAdhharCardImage,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  :SizedBox(),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  try {
                                    File file = await FilePicker.getFile(
                                        type: FileType.image);
                                    uploadDocumentWithParamToServer(
                                        documentType: 'pan_card', file: file);
                                    selectPanController.text =
                                        file.path.split('/').last;
                                    if (file != null) {
                                      isPanSelected = Colors.green;
                                    }
                                    setState(() {});
                                    FocusScope.of(context).unfocus();
                                  } catch (e) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor: Theme.of(context).primaryColor,
                                        controller: selectPanController,
                                        decoration: InputDecoration(
                                          enabled: false,
                                          filled: true,
                                          hintText: Strings.attachPanCardDoc,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey[700],
                                          ),
                                          fillColor: HeaderColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 15.0,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          suffixIcon:
                                              Icon(Icons.camera_alt_outlined),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_sharp,
                                      color: isPanSelected,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              pan == true
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              Strings.selectPanCardImage,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  :SizedBox(),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    Strings.firmRegistration,
                                    style: GoogleFonts.poppins(
                                      decoration: TextDecoration.underline,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                controller: gstController,
                                validator: (String value) {
                                  if (value.isEmpty == true) {
                                    return Strings.enterGSTNumber;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: Strings.GSTNumber,
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.grey[700]),
                                  errorStyle: GoogleFonts.poppins(),
                                  fillColor: HeaderColor,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  try {
                                    File file = await FilePicker.getFile(
                                        type: FileType.image);
                                    uploadDocumentWithParamToServer(
                                        documentType: 'gst_document',
                                        file: file);
                                    selectGstController.text =
                                        file.path.split('/').last;
                                    print(_gstImage);
                                    if (file != null) {
                                      isGstSelected = Colors.green;
                                    }
                                    setState(() {});
                                    FocusScope.of(context).unfocus();
                                  } catch (e) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor: Theme.of(context).primaryColor,
                                        controller: selectGstController,
                                        decoration: InputDecoration(
                                          enabled: false,
                                          filled: true,
                                          hintText: Strings.attachGSTDoc,
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey[700],
                                          ),
                                          fillColor: HeaderColor,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 15.0,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon:
                                              Icon(Icons.camera_alt_outlined),
                                        ),
                                        onEditingComplete: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_circle_sharp,
                                      color: isGstSelected,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              gst == true
                                  ? Padding(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              Strings.SelectGSTDocImage,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.red[700],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  :SizedBox(),
                              SizedBox(height: 10),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      Strings.Address,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  TextFormField(
                                    cursorColor: Theme.of(context).primaryColor,

                                    controller: addressController,
                                    validator: (String value) {
                                      if (value.isEmpty == true) {
                                        return Strings.enterAddress;
                                      }
                                      return null;
                                    },
                                    minLines: 4,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: Strings.registeredAddress,
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.grey[700]),
                                      errorStyle: GoogleFonts.poppins(),
                                      fillColor: HeaderColor,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              dropDownWidget(
                                onCallBack: (String value) {
                                  statesList = [];
                                  cityList = [];
                                  selectedState = null;
                                  selectedCity = null;
                                  getStatesWithReferenceTo(
                                      context: context,
                                      countryID: value,
                                      pageNumber: 1);
                                },
                                hintLabel: Strings.country,
                                dropDownSelection: selectedCountry ?? null,
                                listData: countriesList,
                              ),
                              SizedBox(height: 10),
                              dropDownWidget(
                                onCallBack: (value) {
                                  getCityWithReferenceTo(1, value, context);
                                  cityList = [];
                                  selectedCity = null;
                                },
                                hintLabel: Strings.state,
                                dropDownSelection: selectedState ?? null,
                                listData: statesList,
                              ),
                              SizedBox(height: 10),
                              dropDownWidget(
                                onCallBack: (value) {},
                                hintLabel: Strings.city,
                                dropDownSelection: selectedCity ?? null,
                                listData: cityList,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                controller: pincodeController,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value.isEmpty == true) {
                                    return Strings.enterPinCode;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: Strings.pincode,
                                  hintStyle: GoogleFonts.poppins(
                                      fontSize: 15, color: Colors.grey[700]),
                                  errorStyle: GoogleFonts.poppins(),
                                  fillColor: HeaderColor,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        loginModelObject.loginDictionary[
                                                'termsAndConditions'] =
                                            !((loginModelObject.loginDictionary[
                                                        'termsAndConditions'] ??
                                                    false) ??
                                                true);
                                      });
                                    },
                                    child: Icon(
                                      ((loginModelObject.loginDictionary[
                                                          'termsAndConditions'] !=
                                                      null &&
                                                  loginModelObject
                                                          .loginDictionary[
                                                      'termsAndConditions']) ==
                                              true
                                          ? Icons.check_box
                                          : Icons
                                              .check_box_outline_blank_rounded),
                                      size: 35.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    Strings.termsandConditions,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        _adhharImage == null
                                            ? adhhar = true
                                            : adhhar = false;
                                        _panImage == null
                                            ? pan = true
                                            : pan = false;
                                        _gstImage == null
                                            ? gst = true
                                            : gst = false;
                                        if (_formKey.currentState.validate()) {
                                          if ((loginModelObject.loginDictionary[
                                                          'termsAndConditions'] !=
                                                      null &&
                                                  loginModelObject
                                                          .loginDictionary[
                                                      'termsAndConditions']) ==
                                              true) {
                                            serveRegisterRequestWith();
                                          } else {
                                            ToastUtils.showError(
                                                message: Strings
                                                    .PleaseAcceptTermsAndCondition);
                                          }
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.red[600],
                                        ),
                                        width: Get.width * 0.83,
                                        child: Center(
                                          child: Text(
                                            Strings.register,
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        height: 45.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//-----------------------     FULLNAME WIDGET     ------------------

  Widget fullNameWidget() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: nameController,
      validator: (String value) {
        if (value.isEmpty == true) {
          return Strings.enterFullName;
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        hintText: Strings.fullName,
        hintStyle: GoogleFonts.poppins(fontSize: 15),
        errorStyle: GoogleFonts.poppins(fontSize: 12),
        fillColor: HeaderColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

//=========================      FIRMNAME WIDGET     ================

  Widget firmNameWidget() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: firmController,
      validator: (String value) {
        if (value.isEmpty == true) {
          return Strings.enterFirmName;
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        hintText: Strings.firmName,
        hintStyle: GoogleFonts.poppins(fontSize: 15),
        errorStyle: GoogleFonts.poppins(fontSize: 12),
        fillColor: HeaderColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

// ========================       MOBILE NUMBER         ================

  Widget mobileNoWidget() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: mobileController,
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty == true) {
          return Strings.enterMobileNumber;
        } else if (value.length < 10) {
          return Strings.enterAValidMobileNumber;
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        hintText: Strings.mobileNumber,
        hintStyle: GoogleFonts.poppins(fontSize: 15),
        errorStyle: GoogleFonts.poppins(fontSize: 12),
        fillColor: HeaderColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

// ==========================      EMAIL WIDGET        ===================

  Widget emailWidget() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      controller: emailController,
      // validator: (String value) {
      //   if (value.isEmpty == true) {
      //     return Strings.enterEmail;
      //   } else if (!validator.isEmail(value)) {
      //     return Strings.enterAValidEmail;
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        filled: true,
        hintText: Strings.email,
        hintStyle: GoogleFonts.poppins(fontSize: 15),
        errorStyle: GoogleFonts.poppins(fontSize: 12),
        fillColor: HeaderColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void getCountriesList(int pageNumber) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(Uri.parse(
          Base_URL + countries + '&page=$pageNumber' + '&country_name='));

      print(resp.body);

      if (resp.statusCode == 200 && jsonDecode(resp.body)['status'] == true) {
        if (pageNumber == 1) {
          countriesList = [];
        }
        var tempList = jsonDecode(resp.body)['countries'];
        for (var i = 0; i < tempList.length; i++) {
          countriesList.add(
              DropDownModel(id: tempList[i]['id'], name: tempList[i]['name']));
        }
        if (this.mounted) {
          setState(() {
            // Your state change code goes here
          });
        }
        if (jsonDecode(resp.body)['total_pages'] != pageNumber) {
          getCountriesList(pageNumber + 1);
        } else {}
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(
                context, setMethodToUpdate)
            .show();
      });
    }
  }

  void setMethodToUpdate(Function func) {
    setState(func);
  }

  Future getStatesWithReferenceTo(
      {int pageNumber, String countryID, BuildContext context}) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(Uri.parse(Base_URL +
          states +
          '&country_id=$countryID&page=$pageNumber' +
          '&state_name='));
      if (resp.statusCode == 200 && jsonDecode(resp.body)['status'] == true) {
        if (pageNumber == 1) {
          statesList = [];
        }
        var tempList = jsonDecode(resp.body)['states'];
        for (var i = 0; i < tempList.length; i++) {
          statesList.add(
              DropDownModel(id: tempList[i]['id'], name: tempList[i]['name']));
        }
        if (mounted) {
          setState(() {});
        }
        if (jsonDecode(resp.body)['total_pages'] != pageNumber) {
          getStatesWithReferenceTo(
              pageNumber: pageNumber + 1,
              countryID: countryID,
              context: context);
        } else {}
      }
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }

  Future getCityWithReferenceTo(
      int pageNumber, String stateID, BuildContext context) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http.get(Uri.parse(Base_URL +
          cities +
          '&state_id=$stateID&page=$pageNumber' +
          '&city_name='));
      if (resp.statusCode == 200 && jsonDecode(resp.body)['status'] == true) {
        if (pageNumber == 1) {
          cityList = [];
        }
        var tempList = jsonDecode(resp.body)['cities'];
        for (var i = 0; i < tempList.length; i++) {
          cityList.add(
              DropDownModel(id: tempList[i]['id'], name: tempList[i]['name']));
        }
        if (mounted) {
          setState(() {});
        }
        if (jsonDecode(resp.body)['total_pages'] != pageNumber) {
          getCityWithReferenceTo(pageNumber + 1, stateID, context);
        } else {}
      } else {}
    } else {
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }

  Widget dropDownWidget(
      {hintLabel,
      Function onCallBack,
      String dropDownSelection,
      List<DropDownModel> listData}) {
    return DropdownSearch(
      selectedItem: dropDownSelection,
      onChanged: (value) {
        for (var item in listData) {
          if (item.name == value) {
            onCallBack(item.id.toString());
            if (hintLabel == Strings.country) {
              selectedCountry = item.name;
            } else if (hintLabel == Strings.state) {
              selectedState = item.name;
            } else if (hintLabel == Strings.city) {
              selectedCity = item.name;
            }
          }
        }
      },
      popupBackgroundColor: HeaderColor,
      mode: Mode.DIALOG,
      items: listData.map((DropDownModel value) {
        return '${value.name}';
      }).toList(),
      showSearchBox: true,
      searchBoxDecoration: InputDecoration(
        hintText: Strings.PleaseSearch,
        hintStyle: GoogleFonts.poppins(),
        fillColor: HeaderColor,
        filled: true,
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color:  Theme.of(context).primaryColor,),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        hintText: hintLabel,
        hintStyle: GoogleFonts.poppins(),
        fillColor: HeaderColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.fromLTRB(13, 0, 0, 0),

      ),
      dropDownButton: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
    );
  }

  void uploadDocumentWithParamToServer({
    String documentType,
    File file,
  }) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(Base_URL + documentUpload));
    request.fields["document_type"] = documentType;
    request.fields["comp_id"] = company_id.toString();
    var pic = await http.MultipartFile.fromPath("document_file", file.path);
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var responseDict = jsonDecode(responseString);

    if (responseDict['status'] == true) {
      if (documentType == 'adhar_card') {
        _adhharImage = responseDict['token'];
      } else if (documentType == 'pan_card') {
        _panImage = responseDict['token'];
      } else if (documentType == 'gst_document') {
        _gstImage = responseDict['token'];
      } else {}
    } else {}
  }

  void serveRegisterRequestWith() async {
    Loader().showLoader(context);

    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response response = await http.post(
        Uri.parse(Base_URL + register_URLRetDist),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'user_email': emailController.text,
          'name': nameController.text,
          'user_number': mobileController.text,
          'firm_name': firmController.text,
          'comp_id': company_id,
          'adhar_doc': _adhharImage,
          'pan_doc': _panImage,
          'GST_doc': _gstImage,
          'GST_number': gstController.text,
          'address': addressController.text,
          'country': selectedCountry,
          'state': selectedState,
          'city': selectedCity,
          'pincode': pincodeController.text,
          'terms_conditions': '1',
          'account_type': 'Retailer'
        },
      );
      print('The error encountered here1 ${response.statusCode}');
      print(response.body);
      Loader().hideLoader(context);
      if (response.statusCode == 200) {
        var responseDict = jsonDecode(response.body);

        if (jsonDecode(response.body)['status'].toString() == 'true') {
          ToastUtils.showSuccess(message: responseDict['message'].toString());
          Get.back();
        } else {
          print('The error encountered here');
          print(responseDict);
          ToastUtils.showError(
              message: responseDict['response']['message'].toString() ?? Strings.PleaseCheckForAllMandatoryFields);
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
                : Strings.somethingWentWrong);
      }
    } else {
      Loader().hideLoader(context);
      Future.delayed(Duration.zero, () {
        GlobalModelClass.showAlertForNoInternetConnection(context).show();
      });
    }
  }
}
