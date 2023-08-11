import 'package:fluffychat/utils/responsive/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class ForwardViewStyle {
  static double preferredAppBarSize(BuildContext context) =>
      ResponsiveUtils().isMobile(context) ? 104 : 64;

  static double get paddingBody => 16.0;

  static double get bottomBarHeight => 120.0;

  static double get iconSendSize => 40.0;

  static EdgeInsetsDirectional paddingItemAppbar(BuildContext context) =>
      EdgeInsetsDirectional.only(
        top: ResponsiveUtils().isMobile(context) ? 30 : 0,
      );
}
