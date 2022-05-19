import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class AllCollectionListViewModel{

  AllCollectionPageState state;

  AllCollectionsModel allCollection;

  AllCollectionListViewModel(this.state){
    getCollectionApi();
  }

  getCollectionApi() async{

    var allCollectionList = await RestApi.getAllCollectionFromServer();

    allCollection = allCollectionList;

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}