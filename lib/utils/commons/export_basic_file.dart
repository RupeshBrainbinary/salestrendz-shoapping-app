//common

export 'dart:convert';
export 'dart:async';
export 'package:flutter/cupertino.dart';
export 'package:get/get.dart';
export 'package:flutter/services.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:shoppingapp/app_url_name_companyid.dart';
export 'package:provider/provider.dart';
export 'package:shoppingapp/utils/constants/constants_app_variables.dart';
export 'package:shoppingapp/utils/navigator.dart';
export 'package:shoppingapp/utils/theme_change.dart';
export 'package:shoppingapp/utils/theme_notifier.dart';
export 'package:shoppingapp/widgets/commons/string_res.dart';
export 'package:shoppingapp/models/GlobalModelClass.dart';
export 'package:shoppingapp/models/LoginModelClass.dart';
export 'package:flutter_icons/flutter_icons.dart';
export 'package:shoppingapp/screen/drawer/drawer.dart';
export 'package:shoppingapp/utils/api/api.dart';
export 'package:shoppingapp/widgets/commons/full_screen_loader.dart';
export 'package:auto_size_text/auto_size_text.dart';
export 'package:shoppingapp/utils/utils.dart';
export 'package:shoppingapp/models/BookOrderModel.dart';
export 'package:shoppingapp/utils/commons/colors.dart';
export 'package:shoppingapp/widgets/commons/toast_utils.dart';
export 'package:shoppingapp/main.dart';
export 'package:flutter_svg/flutter_svg.dart';


//drawer screen

export 'package:shoppingapp/screen/activity_pages/contact_page/contact_page.dart';
export 'package:shoppingapp/screen/drawer/drawer_item.dart';
export 'package:shoppingapp/screen/drawer/favorites_product/favorite_products_page.dart';
export 'package:shoppingapp/screen/drawer/received_order/received_orders_page.dart';
export 'package:shoppingapp/screen/home_navigator/home_navigator.dart';
export 'package:shoppingapp/screen/my_profile/my_profile_page.dart';

//resource screen

export 'package:shoppingapp/screen/drawer/about_page/about_page.dart';


//received_order folder

export 'package:shoppingapp/models/received_order_model.dart';
export 'package:shoppingapp/screen/drawer/received_order/received_orders_page.dart';

export 'package:shoppingapp/screen/drawer/received_order/received_order_model.dart';
export 'package:shoppingapp/screen/order_transaction/sales_order/received_order_page.dart';

//live_image_screen

export 'package:image_picker/image_picker.dart';
export 'package:multi_image_picker/multi_image_picker.dart';

//favorite_product folder

export 'package:shoppingapp/models/favorite_product_response_model.dart';
export 'package:shoppingapp/screen/drawer/favorites_product/favorite_products_page.dart';

export 'package:shoppingapp/models/favorite_product_response_model.dart';
export 'package:shoppingapp/screen/product_detail/product_detail_page.dart';
export 'package:shoppingapp/screen/home_screen/widget/wishlist_page_model.dart';

//activity perform screen

export 'package:shoppingapp/screen/activity_pages/contact_page/callheline_screen.dart';
export 'package:shoppingapp/screen/activity_pages/make_payment_page/make_payment_page.dart';
export 'package:shoppingapp/screen/consumer_ui_pages/qrcode_screens/cliam_expiry_qrcode.dart';

//make_payment_page && make_payment_model

export 'package:shoppingapp/screen/activity_pages/make_payment_page/make_payment_model.dart';

export 'package:shoppingapp/models/banklistModel.dart';
export 'package:shoppingapp/models/collectiondetailModel.dart';
export 'package:shoppingapp/models/payment_method_model.dart';
export 'package:shoppingapp/models/suppliermodel.dart';
export 'package:shoppingapp/screen/activity_pages/make_payment_page/make_payment_page.dart';

//all_collection_page && app_collection_model

export 'package:shoppingapp/screen/activity_pages/make_payment_page/allcollection_model.dart';
export 'package:shoppingapp/screen/activity_pages/make_payment_page/make_payment_page.dart';

export 'package:shoppingapp/models/allCollectionModel.dart';
export 'package:shoppingapp/screen/activity_pages/make_payment_page/allcollection_Page.dart';

//contact page

export 'package:url_launcher/url_launcher.dart';
export 'package:shoppingapp/screen/activity_pages/contact_page/contact_page_model.dart';

//forgot password

export 'package:rflutter_alert/rflutter_alert.dart';
export 'package:shoppingapp/screen/auth_screens/login/login_page.dart';
export 'package:shoppingapp/widgets/commons/auth_header.dart';
export 'package:shoppingapp/widgets/commons/shadow_button.dart';

//landing screen

export 'package:getflutter/components/button/gf_button.dart';
export 'package:shared_preferences/shared_preferences.dart';

export 'package:shoppingapp/screen/auth_screens/landing_screen/onboarding_page.dart';

//login screen

export 'package:shoppingapp/screen/auth_screens/forgot_password/forgetpassword.dart';
export 'package:shoppingapp/screen/auth_screens/login/widget/custom_textfield.dart';

export 'package:shoppingapp/screen/auth_screens/login/login_form.dart';
export 'package:shoppingapp/screen/auth_screens/login/widget/custom_alert_view.dart';
export 'package:shoppingapp/screen/auth_screens/register/reg_consumer.dart';


//register

export 'package:file_picker/file_picker.dart';

//rewards_page

export 'package:shoppingapp/screen/rewards_wallet/earned_page.dart';
export 'package:shoppingapp/screen/rewards_wallet/referrals_page.dart';
export 'package:shoppingapp/screen/rewards_wallet/reward_program_page.dart';
export 'package:shoppingapp/screen/rewards_wallet/spent_page.dart';

//product may like page

export 'package:shoppingapp/screen/product_may_like_page/product_like_model.dart';

export 'package:shoppingapp/screen/product_may_like_page/products_may_like_page.dart';

//product detail screen

export 'package:badges/badges.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:expandable/expandable.dart';
export 'package:flutter_svg/svg.dart';
export 'package:getflutter/shape/gf_button_shape.dart';
export 'package:getflutter/types/gf_button_type.dart';
export 'package:shoppingapp/screen/product_detail/product_detail_model.dart';
export 'package:shoppingapp/screen/product_detail/widget/slider_dot.dart';
export 'package:shoppingapp/screen/product_detail/widget/product_image.dart';

export 'package:shoppingapp/models/product_stock_model.dart';

//order transaction

export 'package:marquee/marquee.dart';
export 'package:shoppingapp/screen/order_transaction/purchase_order/purchase_transaction.dart';
export 'package:shoppingapp/screen/order_transaction/sales_order/sales_transaction.dart';
export 'package:shoppingapp/screen/order_transaction/order_transaction.dart';
export 'package:shoppingapp/screen/order_transaction/sales_order/received_order_page.dart';
export 'package:shoppingapp/screen/order_transaction/sales_order/sales_view_model.dart';

export 'package:shoppingapp/models/OdertrasectionModel.dart';
export 'package:shoppingapp/screen/order_transaction/purchase_order/placed_order.dart';
export 'package:shoppingapp/screen/order_transaction/purchase_order/purchase_view_model.dart';

//my profile

export 'package:shoppingapp/screen/my_profile/my_orders/orders_detail_page.dart';
export 'package:shoppingapp/screen/my_profile/profile_setting/profile_settings_page.dart';
export 'package:shoppingapp/screen/my_profile/profile_setting/edit_user/edit_user_info_page.dart';
export 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/new_address/new_adress_input.dart';
export 'package:shoppingapp/screen/my_profile/profile_setting/change_password/widget/textfield_bottomline.dart';
export 'package:shoppingapp/models/ChangePassword.dart';
export 'package:shoppingapp/screen/my_profile/profile_setting/address_pages/new_address/new_adress_page.dart';







