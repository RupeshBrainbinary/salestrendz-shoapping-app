import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';
import 'package:getflutter/getflutter.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? mainColor : Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  void initState() {
    saveOnBoardPageShared();
    super.initState();
  }

  Future saveOnBoardPageShared() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool("onboard", true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
              _buildPageContent(
                image: 'assets/images/onb1.png',
                title: Strings.easyToUse,
                body: Strings.quicklyFindTheProductYouWantToItsEasyInterface,
              ),
              _buildPageContent(
                image: 'assets/images/onb2.png',
                title: Strings.highLevelSecurity,
                body:
                    Strings.yourInformationIsSafeWithAdvancedEncryptionFeature,
              ),
              _buildPageContent(
                image: 'assets/images/onb3.png',
                title: Strings.support724,
                body: Strings.anyProblemYouCanQuicklySupportTeamImmediately,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _currentPage != 2
          ? Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        2,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                      setState(() {});
                      Nav.routeReplacement(context, LoginPage());
                    },
                    splashColor: Colors.blue[50],
                    child: Text(
                      Strings.SKIP,
                      style: GoogleFonts.poppins(color: Colors.blueGrey),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        for (int i = 0; i < _totalPages; i++)
                          i == _currentPage
                              ? _buildPageIndicator(true)
                              : _buildPageIndicator(false)
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                      setState(() {});
                    },
                    splashColor: Colors.blue[50],
                    child: Text(
                      Strings.NEXT,
                      style: GoogleFonts.poppins(color: mainColor),
                    ),
                  )
                ],
              ),
            )
          : Container(
              color: Colors.white,
              height: 60,
              child: Align(
                child: Container(
                  height: 42,
                  width: Get.width / 2,
                  child: GFButton(
                    color: mainColor,
                    fullWidthButton: true,
                    type: GFButtonType.outline,
                    shape: GFButtonShape.pills,
                    onPressed: () {
                      Nav.routeReplacement(context, LoginPage());
                    },
                    child: Text(
                      Strings.GetSTARTED,
                      style: GoogleFonts.poppins(
                        color: mainColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              image,
              height: 180,
            ),
          ),
          SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              height: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, height: 2.0),
          ),
        ],
      ),
    );
  }
}
