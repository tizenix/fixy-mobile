part of persistent_bottom_nav_bar;

class PersistentBottomNavBar extends StatelessWidget {
  const PersistentBottomNavBar({
    Key key,
    this.margin,
    this.confineToSafeArea,
    this.customNavBarWidget,
    this.hideNavigationBar,
    this.onAnimationComplete,
    this.neumorphicProperties = const NeumorphicProperties(),
    this.navBarEssentials,
    this.navBarDecoration,
    this.navBarStyle,
    this.isCustomWidget = false,
  }) : super(key: key);

  final NavBarEssentials navBarEssentials;
  final EdgeInsets margin;
  final NavBarDecoration navBarDecoration;
  final NavBarStyle navBarStyle;
  final NeumorphicProperties neumorphicProperties;
  final Widget customNavBarWidget;
  final bool confineToSafeArea;
  final bool hideNavigationBar;
  final Function(bool, bool) onAnimationComplete;
  final bool isCustomWidget;

  Widget _navBarWidget() => Padding(
        padding: this.margin,
        child: isCustomWidget
            ? this.margin.bottom > 0
                ? SafeArea(
                    top: false,
                    bottom: this.navBarEssentials.navBarHeight == 0.0 ||
                            (this.hideNavigationBar ?? false)
                        ? false
                        : confineToSafeArea ?? true,
                    child: Container(
                      color: this.navBarEssentials.backgroundColor,
                      child: this.customNavBarWidget,
                    ),
                  )
                : Container(
                    color: this.navBarEssentials.backgroundColor,
                    child: SafeArea(
                        top: false,
                        bottom: this.navBarEssentials.navBarHeight == 0.0 ||
                                (this.hideNavigationBar ?? false)
                            ? false
                            : confineToSafeArea ?? true,
                        child: this.customNavBarWidget),
                  )
            : this.navBarStyle == NavBarStyle.style15 ||
                    this.navBarStyle == NavBarStyle.style16
                ? this.margin.bottom > 0
                    ? SafeArea(
                        top: false,
                        right: false,
                        left: false,
                        bottom: this.navBarEssentials.navBarHeight == 0.0 ||
                                (this.hideNavigationBar ?? false)
                            ? false
                            : confineToSafeArea ?? true,
                        child: Container(
                          decoration: getNavBarDecoration(
                            decoration: this.navBarDecoration,
                            color: this.navBarEssentials.backgroundColor,
                            opacity: this
                                .navBarEssentials
                                .items[this.navBarEssentials.selectedIndex]
                                .opacity,
                          ),
                          child: getNavBarStyle(),
                        ),
                      )
                    : Container(
                        decoration: getNavBarDecoration(
                          decoration: this.navBarDecoration,
                          color: this.navBarEssentials.backgroundColor,
                          opacity: this
                              .navBarEssentials
                              .items[this.navBarEssentials.selectedIndex]
                              .opacity,
                        ),
                        child: SafeArea(
                          top: false,
                          right: false,
                          left: false,
                          bottom: this.navBarEssentials.navBarHeight == 0.0 ||
                                  (this.hideNavigationBar ?? false)
                              ? false
                              : confineToSafeArea ?? true,
                          child: getNavBarStyle(),
                        ),
                      )
                : Container(
                    decoration: getNavBarDecoration(
                      decoration: this.navBarDecoration,
                      showBorder: false,
                      color: this.navBarEssentials.backgroundColor,
                      opacity: this
                          .navBarEssentials
                          .items[this.navBarEssentials.selectedIndex]
                          .opacity,
                    ),
                    child: ClipRRect(
                      borderRadius: this.navBarDecoration.borderRadius ??
                          BorderRadius.zero,
                      child: BackdropFilter(
                        filter: this
                                .navBarEssentials
                                .items[this.navBarEssentials.selectedIndex]
                                .filter ??
                            ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          decoration: getNavBarDecoration(
                            showOpacity: false,
                            decoration: navBarDecoration,
                            color: this.navBarEssentials.backgroundColor,
                            opacity: this
                                .navBarEssentials
                                .items[this.navBarEssentials.selectedIndex]
                                .opacity,
                          ),
                          child: SafeArea(
                            top: false,
                            right: false,
                            left: false,
                            bottom: this.navBarEssentials.navBarHeight == 0.0 ||
                                    (this.hideNavigationBar ?? false)
                                ? false
                                : confineToSafeArea ?? true,
                            child: getNavBarStyle(),
                          ),
                        ),
                      ),
                    ),
                  ),
      );

  @override
  Widget build(BuildContext context) {
    return this.hideNavigationBar == null
        ? _navBarWidget()
        : OffsetAnimation(
            hideNavigationBar: this.hideNavigationBar,
            navBarHeight: this.navBarEssentials.navBarHeight,
            onAnimationComplete: (isAnimating, isComplete) {
              this.onAnimationComplete(isAnimating, isComplete);
            },
            child: _navBarWidget(),
          );
  }

  PersistentBottomNavBar copyWith(
      {int selectedIndex,
      double iconSize,
      int previousIndex,
      Color backgroundColor,
      Duration animationDuration,
      List<PersistentBottomNavBarItem> items,
      ValueChanged<int> onItemSelected,
      double navBarHeight,
      EdgeInsets margin,
      NavBarStyle navBarStyle,
      double horizontalPadding,
      NeumorphicProperties neumorphicProperties,
      Widget customNavBarWidget,
      Function(int) popAllScreensForTheSelectedTab,
      bool popScreensOnTapOfSelectedTab,
      NavBarDecoration navBarDecoration,
      NavBarEssentials navBarEssentials,
      bool confineToSafeArea,
      ItemAnimationProperties itemAnimationProperties,
      Function onAnimationComplete,
      bool hideNavigationBar,
      bool isCustomWidget,
      EdgeInsets padding}) {
    return PersistentBottomNavBar(
        confineToSafeArea: confineToSafeArea ?? this.confineToSafeArea,
        margin: margin ?? this.margin,
        neumorphicProperties: neumorphicProperties ?? this.neumorphicProperties,
        navBarStyle: navBarStyle ?? this.navBarStyle,
        hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
        customNavBarWidget: customNavBarWidget ?? this.customNavBarWidget,
        onAnimationComplete: onAnimationComplete ?? this.onAnimationComplete,
        navBarEssentials: navBarEssentials ?? this.navBarEssentials,
        isCustomWidget: isCustomWidget ?? this.isCustomWidget,
        navBarDecoration: navBarDecoration ?? this.navBarDecoration);
  }

  bool opaque(int index) {
    return this.navBarEssentials.items == null
        ? true
        : !(this.navBarEssentials.items[index].opacity < 1.0);
  }

  Widget getNavBarStyle() {
    if (isCustomWidget) {
      return customNavBarWidget;
    } else {
      switch (navBarStyle) {
        case NavBarStyle.style9:
          return BottomNavStyle9(
            navBarEssentials: this.navBarEssentials,
          );
        case NavBarStyle.neumorphic:
          return NeumorphicBottomNavBar(
            navBarEssentials: this.navBarEssentials,
            neumorphicProperties: this.neumorphicProperties,
          );
        default:
          return BottomNavSimple(
            navBarEssentials: this.navBarEssentials,
          );
      }
    }
  }
}
