import 'package:fluffychat/di/global/get_it_initializer.dart';
import 'package:fluffychat/utils/responsive/responsive_utils.dart';
import 'package:flutter/cupertino.dart';

class TwakeHeaderStyle {
  static ResponsiveUtils responsive = getIt.get<ResponsiveUtils>();
  static const double toolbarHeight = 56.0;
  static const double leadingWidth = 76.0;
  static const double titleHeight = 36.0;
  static const double closeIconSize = 24.0;
  static const double widthSizedBox = 16.0;
  static const double textBorderRadius = 24.0;
  static const int flexTitle = 6;
  static const int flexActions = 3;

  static bool isDesktop(BuildContext context) => responsive.isDesktop(context);

  static AlignmentGeometry alignment = AlignmentDirectional.centerStart;

  static const EdgeInsetsDirectional actionsPadding =
      EdgeInsetsDirectional.only(
    end: 16,
  );

  static const EdgeInsetsDirectional paddingTitleHeader =
      EdgeInsetsDirectional.only(
    start: 16,
  );

  static const EdgeInsetsDirectional leadingPadding =
      EdgeInsetsDirectional.only(
    start: 26,
  );

  static const EdgeInsetsDirectional textButtonPadding =
      EdgeInsetsDirectional.all(8);

  static const EdgeInsetsDirectional counterSelectionPadding =
      EdgeInsetsDirectional.only(start: 4);
}
