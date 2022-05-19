import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class SupplierListViewModel {
  MakePaymentPageState state;

  SupllierModel supplier;

  SupplierListViewModel(this.state) {
    getSupplierApi();
  }

  getSupplierApi() async {
    var supplierList = await RestApi.getSupplierListFromServer();

    if (supplierList == null) {
      // ignore: deprecated_member_use
      supplier = SupllierModel(companySupplier: List());
    } else {
      supplier = supplierList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class PaymentMethodViewModel {
  MakePaymentPageState state;

  PaymentMethodModel paymentMethod;

  PaymentMethodViewModel(this.state) {
    getPaymentMethodApi();
  }

  getPaymentMethodApi() async {
    var paymentMethodList = await RestApi.getPaymentMethodListFromServer();

    if (paymentMethodList == null) {
      // ignore: deprecated_member_use
      paymentMethod = PaymentMethodModel(outwardPaymentMethod: List());
    } else {
      paymentMethod = paymentMethodList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class BankListViewModel {
  MakePaymentPageState state;

  BankListModel bankList;

  BankListViewModel(this.state) {
    getBankListApi();
  }

  getBankListApi() async {
    var bankListDetail = await RestApi.getBankListFromServer();

    if (bankListDetail == null) {
      // ignore: deprecated_member_use
      bankList = BankListModel(outwardBanklist: List());
    } else {
      bankList = bankListDetail;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

class CollectionDetailViewModel {
  MakePaymentPageState state;

  CollectionDetailModel collectionDetail;

  CollectionDetailViewModel(this.state) {
    getCollectionDetailApi();
  }

  getCollectionDetailApi() async {
    var collectionDetailList = await RestApi.getCollectionDetailFromServer(66);

    if (collectionDetailList == null) {
      // ignore: deprecated_member_use
      collectionDetail = CollectionDetailModel(collectionDetails: List());
    } else {
      collectionDetail = collectionDetailList;
    }

    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }
}

// class CollectionSubmitViewModel{
//
//   MakePaymentPageState state;
//
//   CollectionSubmitViewModel(this.state){
//     getCollectionDetailApi();
//   }
//
//   getCollectionDetailApi() async{
//
//      await RestApi.postCollectionToServer(
//       state.selectedDate.toString(),
//       state.selectsupplier.toString(),
//       state.onaccountamount.toString(),
//       state.collectionamount.toString(),
//       state.invoiceid.toString(),
//       state.invoiceamount.toString(),
//       state.selectpaymentmode.toString(),
//       state.selectbank.toString(),
//       state.remark.text.toString()
//     );
//
//     state.setState(() {});
//   }
// }
