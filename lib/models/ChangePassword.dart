class ChangePassword {
  int userId;
  int loggedInUserid;
  int compId;

  String password;

  String newPassword;
  String retypePassword;

  bool isSelected;

  //SharedPreferences prefs;

  // ignore: non_constant_identifier_names
  ChangePassword({
    this.userId,
    this.loggedInUserid,
    this.compId,
    this.newPassword,
    this.retypePassword,
    this.password,
  });

/* //Setting values in prefs root
  void setValueForKeyInPreferences({String key, String value}) {
    this.prefs.setString(key, value);
  }

  //getting values from prefs root
  String getValueForKeyInPreferences({String key}) {
    return prefs.getString(key) ?? 'null';
  }

  // Getting values from login response
  String getValueForKeyFromLoginResponse({String key}) {
    var loginResponseString = prefs.getString(loginResponse);
    var loginResponseDict = jsonDecode(loginResponseString);

    return loginResponseDict[key];
  }*/
}
