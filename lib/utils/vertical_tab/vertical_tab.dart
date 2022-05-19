import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/utils/theme_notifier.dart';

enum IndicatorSide { start, end }

/// A vertical tab widget for flutter
class VerticalTabs extends StatefulWidget {
  final Key key;
  final int initialIndex;
  final double tabsWidth;
  final double indicatorWidth;
  final double height;
  final IndicatorSide indicatorSide;
  final List<Tab> tabs;
  final List<String> tabsTitle;
  final List<Widget> contents;
  final TextDirection direction;
  final Color indicatorColor;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color selectedTabBackgroundColor;
  final Color tabBackgroundColor;
  final TextStyle selectedTabTextStyle;
  final TextStyle tabTextStyle;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function(int tabIndex) onSelect;
  final Color backgroundColor;

  VerticalTabs(
      {this.key,
      @required this.tabs,
      @required this.contents,
      this.tabsWidth = 100,
      this.indicatorWidth = 3,
      this.height,
      this.indicatorSide,
      this.initialIndex = 0,
      this.direction = TextDirection.ltr,
      this.indicatorColor = Colors.green,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.horizontal,
      this.selectedTabBackgroundColor = const Color(0x1100ff00),
      this.tabBackgroundColor = const Color(0xfff8f8f8),
      this.selectedTabTextStyle = const TextStyle(color: Colors.black),
      this.tabTextStyle = const TextStyle(color: Colors.black38),
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.tabsShadowColor = Colors.black54,
      this.tabsElevation = 2.0,
      this.onSelect,
      this.backgroundColor,
      this.tabsTitle})
      : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  @override
  _VerticalTabsState createState() => _VerticalTabsState();
}

class _VerticalTabsState extends State<VerticalTabs>
    with TickerProviderStateMixin {
  int _selectedIndex;
  bool _changePageByTapView;

  AnimationController animationController;
  Animation<double> animation;
  Animation<RelativeRect> rectAnimation;

  PageController pageController = PageController();

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }
    _selectTab(widget.initialIndex);

    if (widget.disabledChangePageFromContentView == true)
      pageScrollPhysics = NeverScrollableScrollPhysics();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.initialIndex);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<ThemeNotifier>(context);
//    Border border = Border(
//        right: BorderSide(
//            width: 0.5, color: widget.dividerColor));
//    if (widget.direction == TextDirection.rtl) {
//      border = Border(
//          left: BorderSide(
//              width: 0.5, color: widget.dividerColor));
//    }

    return Directionality(
      textDirection: widget.direction,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    color: themeColor.getColor(),
                    height: widget.height,
                    width: widget.tabsWidth,
                    child: ListView.builder(
                      itemCount: widget.tabs.length,
                      itemBuilder: (context, index) {
                        Tab tab = widget.tabs[index];

                        if (widget.direction == TextDirection.rtl) {}

                        if (tab.child != null) {
                        } else {}

                        if (_selectedIndex == index) if (widget.direction ==
                            TextDirection.rtl) {
                        } else {}

                        return Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _changePageByTapView = true;
                                setState(() {
                                  _selectTab(index);
                                });

                                pageController.animateToPage(index,
                                    duration: widget.changePageDuration,
                                    curve: widget.changePageCurve);
                              },
                              child: Container(
                                  color: widget.tabBackgroundColor,
                                  alignment: Alignment.center,
                                  child: index == _selectedIndex
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          padding: EdgeInsets.only(
                                              left: 4,
                                              right: 4,
                                              top: 12,
                                              bottom: 12),
                                          child: Align(
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: widget.tabsTitle[index],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: widget
                                                        .tabBackgroundColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          width: 24,
                                          margin: EdgeInsets.only(top: 32,bottom: 10),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(top: 30,bottom: 10),
                                          padding: EdgeInsets.only(
                                            top: 12,
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: RichText(
                                              text: TextSpan(
                                                text: widget.tabsTitle[index],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ))),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: PageView.builder(
                        scrollDirection: widget.contentScrollAxis,
                        physics: pageScrollPhysics,
                        onPageChanged: (index) {
                          if (_changePageByTapView == false ||
                              _changePageByTapView == null) {
                            _selectTab(index);
                          }
                          if (_selectedIndex == index) {
                            _changePageByTapView = null;
                          }
                          setState(() {});
                        },
                        controller: pageController,

                        // the number of pages
                        itemCount: widget.contents.length,

                        // building pages
                        itemBuilder: (BuildContext context, int index) {
                          return widget.contents[index];
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTab(index) {
    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();

    if (widget.onSelect != null) {
      widget.onSelect(_selectedIndex);
    }
  }
}