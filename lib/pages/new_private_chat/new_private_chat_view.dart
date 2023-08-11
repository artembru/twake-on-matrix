import 'package:fluffychat/pages/new_private_chat/new_private_chat.dart';
import 'package:fluffychat/pages/new_private_chat/widget/expansion_list.dart';
import 'package:fluffychat/pages/new_private_chat/widget/new_private_appbar.dart';
import 'package:fluffychat/pages/new_private_chat/widget/new_private_appbar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class NewPrivateChatView extends StatelessWidget {
  final NewPrivateChatController controller;

  const NewPrivateChatView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          NewPrivateAppBarStyle.appbarHeight(context),
        ),
        child: NewPrivateAppBar(
          title: L10n.of(context)!.newChat,
          searchContactsController: controller.searchContactsController,
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(left: 8.0, right: 10.0),
        controller: controller.fetchContactsController.scrollController,
        child: ExpansionList(
          newPrivateChatController: controller,
        ),
      ),
    );
  }
}
