import 'package:flutter/material.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

class RewardsPage extends StatefulWidget {
  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  PageController _pageController = PageController();
  int _currentIndex = 0;

  void onPageChanged(int value) {
    setState(() {
      this._currentIndex = value;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Current page --> $runtimeType");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          Strings.RewardProgram,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => RewardProgram());
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
                right: 10,
                bottom: 10,
              ),
              padding: EdgeInsets.only(
                left: 13,
                right: 13,
                bottom: 10,
                top: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Colors.grey[500],
              ),
              child: Image.asset(
                "assets/icons/ic_question.png",
                height: 8,
                width: 12,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: Get.height * 0.3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/rewards_pic.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 25),
                          child: Text(
                            Strings.AvailablePoint,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            "2500",
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, bottom: 20, right: 10),
                      child: Text(
                        Strings.RewardsDescription,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 2),
          SizedBox(height: 8),
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _pageController.jumpToPage(0);
                              });
                            },
                            child: Container(
                              child: Text(
                                "Earned",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: _currentIndex == 0
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 2.5,
                            width: Get.width * 0.33,
                            color: _currentIndex == 0
                                ? Colors.red
                                : Colors.grey[200],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _pageController.jumpToPage(1);
                              });
                            },
                            child: Container(
                              child: Text(
                                "Spent",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: _currentIndex == 1
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: Get.width * 0.33,
                            height: 2.5,
                            color: _currentIndex == 1
                                ? Colors.red
                                : Colors.grey[200],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _pageController.jumpToPage(2);
                              });
                            },
                            child: Container(
                              child: Text(
                                "Referrals",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: _currentIndex == 2
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: Get.width * 0.33,
                            height: 2.5,
                            color: _currentIndex == 2
                                ? Colors.red
                                : Colors.grey[200],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: onPageChanged,
                controller: _pageController,
                children: [
                  EarnedTransaction(),
                  SpentTransaction(),
                  ReferralsTransaction()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
