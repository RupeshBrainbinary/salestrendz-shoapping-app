import 'package:shoppingapp/app_url_name_companyid.dart';

//Login keys
const loginResponse = 'loginResponse';
const userName = 'user_fname';
const userMobileNumber = 'user_number';
const userEmail = 'user_email';

const currencySymbol = '₹';

String loggedInUserId;

const String Login_URL = 'signin';
const register_URL = 'signup/registerConsumerAccount';
const change_password = 'changePassword';
const register_URLRetDist = 'signup/registerAccount';
const countries = 'countries?comp_id=$company_id&limit=100';
const states = 'states?comp_id=$company_id&limit=100';
const cities = 'cities?comp_id=$company_id&limit=100';
const documentUpload = 'documentUpload';
const uploadImage = 'uploadImage';
const forgotPassword = 'forgetpassword';
const productsList = 'productsList?comp_id=$company_id';
const getCompanyCategories = 'getCompanyCategories?comp_id=$company_id';
const addAddressApi = 'address/save?comp_id=$company_id&format=json';

const getBannerProduct = 'getBannerFeatureProducts?comp_id=$company_id';
const getMyOrdersList = 'getMyOrdersList';
const bookOrder = 'insertOrder';
const insertcollection = 'insertcollection';
const productDetails = 'productDetails?comp_id=$company_id';
const addressList = 'get/address/list?comp_id=$company_id';
const retailerSupplierList = 'getRetailerSupplier?comp_id=$company_id';
const productstock = 'getProductStock?comp_id=$company_id';
const getCustomerOrderList = 'getMyOrdersList';
const getOrderDetails = 'getOrderDetails?comp_id=$company_id';
const retailersOrders = 'retailersOrders?';
const getCallHelplineList = 'getCallHelplineList';
const getAllWishList = 'getAllWishlist';
const collectionDetail = 'collectionDetails?';
const allcollection = 'allCollections?';
const banklist = 'getbanklist?';
const homesearch = 'homeProductSearch?';
const appVersion = 'appVersion?';
const broucher = "brochures/retailers";
const getSchemeAppliedInfo =
    'https://beta-ow-api-v3.salestrendz.com/api/schemes/getSchemeAppliedInfo';

const brochures =
    "https://beta-ow-api-v3.salestrendz.com/api/v4/brochures/retailers";
const QRcode =
    "getCompanyQRCode?comp_id=$company_id";

const changeOrderStatus = 'changeStatus?comp_id=$company_id';

enum RegisteredAs {
  Retailer,
  Distributor,
  Consumer,
}
