import 'package:fluffychat/config/first_column_inner_routes.dart';
import 'package:fluffychat/pages/chat_list/chat_list_header_style.dart';
import 'package:fluffychat/pages/dialer/pip/dismiss_keyboard.dart';
import 'package:fluffychat/widgets/twake_components/twake_icon_button.dart';
import 'package:fluffychat/widgets/app_bars/searchable_app_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:linagora_design_flutter/linagora_design_flutter.dart';

class SearchableAppBar extends StatelessWidget {
  final ValueNotifier<bool> searchModeNotifier;
  final FocusNode focusNode;
  final String title;
  final String? hintText;
  final TextEditingController textEditingController;
  final Function() openSearchBar;
  final Function() closeSearchBar;
  final bool isFullScreen;

  const SearchableAppBar({
    super.key,
    required this.searchModeNotifier,
    required this.title,
    this.hintText,
    required this.focusNode,
    required this.textEditingController,
    required this.openSearchBar,
    required this.closeSearchBar,
    this.isFullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 4),
        child: Container(
          color: LinagoraStateLayer(
            LinagoraSysColors.material().surfaceTint,
          ).opacityLayer1,
          height: 1,
        ),
      ),
      backgroundColor: LinagoraSysColors.material().onPrimary,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFullScreen == true) ...[
                  TwakeIconButton(
                    icon: Icons.arrow_back,
                    onTap: () {
                      if (!FirstColumnInnerRoutes.instance
                          .goRouteAvailableInFirstColumn()) {
                        Navigator.of(context).maybePop();
                      } else {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.go('/rooms');
                        }
                      }
                    },
                    tooltip: L10n.of(context)!.back,
                    paddingAll: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                ] else ...[
                  const SizedBox(width: 56.0),
                ],
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: searchModeNotifier,
                    builder: (context, searchModeNotifier, child) {
                      if (searchModeNotifier) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(top: 10.0),
                          child: _textFieldBuilder(context),
                        );
                      }
                      return Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      );
                    },
                  ),
                ),
                if (isFullScreen) ...[
                  ValueListenableBuilder(
                    valueListenable: searchModeNotifier,
                    builder: (context, searchModeNotifier, child) {
                      if (searchModeNotifier) {
                        return TwakeIconButton(
                          onTap: closeSearchBar,
                          tooltip: L10n.of(context)!.close,
                          icon: Icons.close,
                          paddingAll: 10.0,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 6.0,
                          ),
                        );
                      }
                      return TwakeIconButton(
                        icon: Icons.search,
                        onTap: openSearchBar,
                        tooltip: L10n.of(context)!.search,
                        paddingAll: 10.0,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                      );
                    },
                  ),
                ] else ...[
                  TwakeIconButton(
                    onTap: () => context.pop(),
                    tooltip: L10n.of(context)!.close,
                    icon: Icons.close,
                    paddingAll: 10.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 6.0,
                    ),
                  ),
                ],
              ],
            ),
            if (!isFullScreen)
              Padding(
                padding: SearchableAppBarStyle.textFieldWebPadding,
                child: _textFieldBuilder(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldBuilder(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        dismissKeyboard();
      },
      focusNode: focusNode,
      autofocus: true,
      maxLines: SearchableAppBarStyle.textFieldMaxLines,
      buildCounter: (
        BuildContext context, {
        required int currentLength,
        required int? maxLength,
        required bool isFocused,
      }) =>
          const SizedBox.shrink(),
      maxLength: SearchableAppBarStyle.textFieldMaxLength,
      cursorHeight: 26,
      scrollPadding: const EdgeInsets.all(0),
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: SearchableAppBarStyle.textFieldContentPadding,
        isCollapsed: true,
        filled: !isFullScreen,
        hintText: hintText,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ChatListHeaderStyle.searchRadiusBorder,
          ),
        ),
        prefixIcon: !isFullScreen
            ? Icon(
                Icons.search_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              )
            : null,
        suffixIcon: const SizedBox.shrink(),
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: LinagoraRefColors.material().neutral[60],
            ),
      ),
    );
  }
}
