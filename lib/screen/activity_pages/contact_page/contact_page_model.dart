import 'package:shoppingapp/models/helpline_model.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class ContactViewModel {
  ContactPageState state;

  HelplineModel contact;

  ContactViewModel(this.state) {
    getCallHelplineApi();
  }

  getCallHelplineApi() async {
    var aboutList = await RestApi.getCallHelplineListFromServer();

    if (aboutList == null) {
      // ignore: deprecated_member_use
      contact = HelplineModel(callHelplines: List());
    } else {
      contact = aboutList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

/// help line view model
class HelpLineViewModel {
  CallHelplineState state;

  HelplineModel contact;

  HelpLineViewModel(this.state) {
    getCallHelplineApi();
  }

  getCallHelplineApi() async {
    var aboutList = await RestApi.getCallHelplineListFromServer();

    if (aboutList == null) {
      // ignore: deprecated_member_use
      contact = HelplineModel(callHelplines: List());
    } else {
      contact = aboutList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
