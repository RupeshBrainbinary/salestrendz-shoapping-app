import 'dart:convert';
import 'dart:io';
import 'package:shoppingapp/screen/auth_screens/register/reg_retailer.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/address_page.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart' as validator;


class NewAddressPage extends StatefulWidget {
  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addTitleController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List gender = [Strings.male, Strings.female];
  String select = Strings.male;
  int selectId;

  List<DropDownModel> countriesList = [];
  List<DropDownModel> statesList = [];
  String selectedCountry;
  String selectedState;
  int countryId;
  int stateId;

  final List<DropdownMenuItem> items = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool country = false;
  bool state = false;

  @override
  void initState() {
    super.initState();
    getCountriesList(1);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
    print("Current screen => $runtimeType");
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: "i");
        return false;
      },
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(
              FocusNode(),
            );
          },
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () async {
                  await Get.back();
                },
                child: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.chevron_left,
                  size: 25,
                ),
              ),
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                Strings.MyAddress,
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                if (select == Strings.male) {
                  selectId = 1;
                } else {
                  selectId = 2;
                }
                countryId == null ? country = true : country = false;
                stateId == null ? state = true : state = false;
                if (_formKey.currentState.validate()) {
                  if (countryId != null && stateId != null) {
                    callApiForAddress();
                  }
                }

                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 14,
                  right: 14,
                  bottom: 5,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Strings.Save,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                height: 42,
                decoration: BoxDecoration(
                  color: themeColor.getColor(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0xFFFCFCFC),
            body: Container(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          NewAddressInput(
                            textEditingController: addTitleController,
                            labelText: Strings.AddressTitle,
                            hintText: '',
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.addressvalidate;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            textEditingController: nameController,
                            labelText: Strings.NameSurname,
                            hintText: '',
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.namevalidate;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            textEditingController: streetController,
                            labelText: Strings.streetname,
                            hintText: '',
                            isEmail: true,
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.streetvalidate;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            textEditingController: townController,
                            labelText: Strings.entertown,
                            hintText: '',
                            isEmail: true,
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.townvalidate;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            keyboardType: TextInputType.number,
                            textEditingController: pincodeController,
                            labelText: Strings.pincode,
                            hintText: '',
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.pincodevalidate;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            textEditingController: emailController,
                            labelText: Strings.email,
                            hintText: '',
                            // validator: (String value) {
                            //   if (value.isEmpty == true) {
                            //     return Strings.enterEmail;
                            //   } else if (!validator.isEmail(value)) {
                            //     return Strings.enterAValidEmail;
                            //   }
                            //   return null;
                            // },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 8),
                          NewAddressInput(
                            keyboardType: TextInputType.number,
                            textEditingController: mobileController,
                            labelText: Strings.MobilePhone,
                            hintText: '',
                            validator: (String value) {
                              if (value.isEmpty == true) {
                                return Strings.enterMobileNumber;
                              } else if (value.length < 10) {
                                return Strings.enterAValidMobileNumber;
                              }
                              return null;
                            },
                            onSaved: (String value) {},
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addRadioButton(0, Strings.male),
                              addRadioButton(1, Strings.female),
                            ],
                          ),
                          SizedBox(height: 10),
                          dropDownWidget(
                            onCallBack: (String value) {
                              statesList = [];
                              selectedState = null;
                              getStatesWithReferenceTo(1, value, context);
                            },
                            hintLabel: Strings.country,
                            dropDownSelection: selectedCountry ?? null,
                            listData: countriesList,
                          ),
                          country == true
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          Strings.selectcountry,
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
                          country == true
                              ? SizedBox(height: 10)
                              : SizedBox(height: 25),
                          dropDownWidget(
                            onCallBack: (value) {},
                            hintLabel: Strings.state,
                            dropDownSelection: selectedState ?? null,
                            listData: statesList,
                          ),
                          state == true
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          Strings.selectstate,
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
                          SizedBox(height: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  callApiForAddress() async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      String loggedInUserId = LoginModelClass.loginModelObj
          .getValueForKeyFromLoginResponse(key: 'user_id');
      Loader().showLoader(context);

      Map addressMap = {
        "name": nameController.text,
        "street_address": streetController.text,
        "town": townController.text,
        "state": selectedState.toString(),
        "state_id": stateId.toString(),
        "contry": selectedCountry.toString(),
        "country_id": countryId.toString(),
        "pincode": pincodeController.text,
        "email": emailController.text,
        "phone": int.parse(mobileController.text),
        "user_type": select.toString(),
        "user_type_id": selectId,
        "user_id": loggedInUserId.toString(),
        "address_label": addTitleController.text,
        "is_default_address": 1
      };

      addressListForBookOrder.add(addressMap);

      var jsonData = {'delivery_addresses': addressListForBookOrder};
      http.Response response = await http.post(
          Uri.parse(Base_URL + addAddressApi + '&logged_in_userid=$loggedInUserId'),
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: LoginModelClass.loginModelObj
                .getValueForKeyFromLoginResponse(key: 'token')
          },
          body: jsonEncode(jsonData));
      if (response.statusCode == 200) {
        Loader().hideLoader(context);
        var jsonResp = jsonDecode(response.body);
        print(jsonResp);

        if (jsonResp['status'] == true) {
          var titleString = '';
          if (jsonResp['status'] == true) {
            titleString = (jsonResp['message']);
          } else {
            titleString = (jsonResp['status'])['message'].toString();
          }
          ToastUtils.showSuccess(message: titleString);
          nameController.text = '';
          mobileController.text = '';
          addressController.text = '';
          addTitleController.text = '';
          Get.back();
        } else {
          var titleString = '';
          if (jsonResp['response'] == null) {
            titleString = (jsonResp['message']);
          } else {
            titleString = (jsonResp['response'])['message'].toString();
          }
          ToastUtils.showError(message: titleString);
        }
      } else {
        Loader().hideLoader(context);
        print('URL Calling Failed' + response.statusCode.toString());
      }
    }
  }

  void getCountriesList(int pageNumber) async {
    if (GlobalModelClass.internetConnectionAvaiable() == true) {
      http.Response resp = await http
          .get(Uri.parse(Base_URL + countries + '&page=$pageNumber' + '&country_name='));

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
      int pageNumber, String countryID, BuildContext context) async {
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
          getStatesWithReferenceTo(pageNumber + 1, countryID, context);
        } else {}
      }
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
              countryId = item.id;
            } else if (hintLabel == Strings.state) {
              selectedState = item.name;
              stateId = item.id;
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
        focusColor: Theme.of(context).primaryColor,
        hintText: Strings.PleaseSearch,
        hintStyle: GoogleFonts.poppins(),
        fillColor: HeaderColor,
        filled: true,
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor,),
        ),
      ),
      dropdownSearchDecoration: InputDecoration(
        hintText: hintLabel,
        hintStyle: GoogleFonts.poppins(fontSize: 15,color: Theme.of(context).primaryColor,),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(13, 0, 0, 0),
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor,),
        ),
      ),
      dropDownButton: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
    );
  }
}
