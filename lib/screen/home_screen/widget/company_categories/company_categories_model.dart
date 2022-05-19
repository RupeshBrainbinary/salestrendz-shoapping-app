import 'package:shoppingapp/models/company_categories_details_model.dart';
import 'package:shoppingapp/utils/api/api.dart';
import 'accountPage.dart';

class CompanyCategoriesViewModel {
  AccountScreenState state;

  CategoriesModel companyCategories;

  CompanyCategoriesViewModel(this.state) {
    getAboutUsApi();
  }

  getAboutUsApi() async {
    var aboutList = await RestApi.getCategoriesFromServer();

    if (aboutList == null) {
      // ignore: deprecated_member_use
      companyCategories = CategoriesModel(categories: List(),brands: List());
    } else {
      companyCategories = aboutList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}
