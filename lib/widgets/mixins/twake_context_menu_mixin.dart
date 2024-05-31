import 'package:fluffychat/widgets/context_menu/context_menu_action.dart';
import 'package:fluffychat/widgets/context_menu/twake_context_menu.dart';
import 'package:fluffychat/widgets/mixins/twake_context_menu_style.dart';
import 'package:fluffychat/widgets/twake_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Show a [TwakeContextMenu] on the given [BuildContext]. For other parameters, see [TwakeContextMenu].
mixin TwakeContextMenuMixin {
  Future<int?> showTwakeContextMenu({
    required List<ContextMenuAction> listActions,
    required Offset offset,
    required BuildContext context,
    double? verticalPadding,
    VoidCallback? onClose,
  }) async {
    int? result;
    await showDialog<int>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (dialogContext) => TwakeContextMenu(
        dialogContext: dialogContext,
        listActions: listActions,
        position: offset,
        verticalPadding: verticalPadding,
      ),
    ).then((value) {
      result = value;
      onClose?.call();
    });
    return result;
  }

  Widget contextMenuItem(
    BuildContext context,
    String nameAction, {
    IconData? iconAction,
    String? imagePath,
    Color? colorIcon,
    double? iconSize,
    TextStyle? styleName,
    EdgeInsets? padding,
    void Function()? onCallbackAction,
    bool isClearCurrentPage = true,
  }) {
    return InkWell(
      onTap: () {
        if (isClearCurrentPage) {
          TwakeApp.router.routerDelegate.pop();
        }
        onCallbackAction!.call();
      },
      child: _itemBuilder(
        context,
        nameAction,
        iconAction: iconAction,
        imagePath: imagePath,
        colorIcon: colorIcon,
        iconSize: iconSize,
        styleName: styleName,
        padding: padding,
      ),
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    String nameAction, {
    IconData? iconAction,
    String? imagePath,
    Color? colorIcon,
    double? iconSize,
    TextStyle? styleName,
    EdgeInsets? padding,
  }) {
    Widget buildIcon() {
      // We try to get the SVG first and then the IconData
      if (imagePath != null) {
        return SvgPicture.asset(
          imagePath,
          width: iconSize ?? TwakeContextMenuStyle.defaultItemIconSize,
          height: iconSize ?? TwakeContextMenuStyle.defaultItemIconSize,
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            colorIcon ?? TwakeContextMenuStyle.defaultItemColorIcon(context)!,
            BlendMode.srcIn,
          ),
        );
      }

      if (iconAction != null) {
        return Icon(
          iconAction,
          size: iconSize ?? TwakeContextMenuStyle.defaultItemIconSize,
          color:
              colorIcon ?? TwakeContextMenuStyle.defaultItemColorIcon(context),
        );
      }

      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding ?? TwakeContextMenuStyle.defaultItemPadding,
      child: SizedBox(
        child: Row(
          children: [
            buildIcon(),
            const SizedBox(width: TwakeContextMenuStyle.defaultItemElementsGap),
            Expanded(
              child: Text(
                nameAction,
                style: styleName ??
                    TwakeContextMenuStyle.defaultItemTextStyle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
