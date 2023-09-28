import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_state.dart';
import 'package:fluffychat/resource/image_paths.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benchmarkResults = controller.benchmarkResults;
    return LoginScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 16.0),
          child: SvgPicture.asset(
            ImagePaths.icTwakeLogo,
            width: 100,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onBackground,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // display a prominent banner to import session for TOR browser
            // users. This feature is just some UX sugar as TOR users are
            // usually forced to logout as TOR browser is non-persistent
            AnimatedContainer(
              height: controller.isTorBrowser ? 64 : 0,
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: Text(L10n.of(context)!.hydrateTor),
                  subtitle: Text(L10n.of(context)!.hydrateTorLong),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: controller.restoreBackup,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: HomeserverTextField(
                controller: controller,
                benchmarkResults: benchmarkResults,
              ),
            ),
            const SizedBox(height: 4.0),
            if (controller.state == HomeserverState.wrongServerName)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  L10n.of(context)!.serverNameWrongExplain,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        letterSpacing: 0.25,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'loginButton',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        maximumSize: const Size.fromHeight(40),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () => controller.loginButtonPressed(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_getLabelLoginButton(context)],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => UrlLauncher(context, AppConfig.privacyUrl)
                        .openUrlInAppBrowser(),
                    child: Text(L10n.of(context)!.privacy),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLabelLoginButton(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          letterSpacing: 0.1,
        );
    switch (controller.state) {
      case HomeserverState.otherLoginMethod:
        return Text(L10n.of(context)!.loginWithSSO, style: textStyle);
      case HomeserverState.loading:
        return const Expanded(child: LinearProgressIndicator());
      case HomeserverState.ssoLoginServer:
      case HomeserverState.wrongServerName:
        return Text(L10n.of(context)!.loginWithSSO, style: textStyle);
    }
  }
}

class HomeserverTextField extends StatelessWidget {
  const HomeserverTextField({
    super.key,
    required this.controller,
    required this.benchmarkResults,
  });

  final HomeserverPickerController controller;
  final List<HomeserverBenchmarkResult>? benchmarkResults;

  @override
  Widget build(BuildContext context) {
    return _buildTypeAheadField(context);
  }

  TypeAheadField<HomeserverBenchmarkResult> _buildTypeAheadField(
    BuildContext context,
  ) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        onEditingComplete: () => controller.loginButtonPressed(),
        autofocus: controller.state != HomeserverState.ssoLoginServer,
        focusNode: controller.homeserverFocusNode,
        autocorrect: false,
        enabled: true,
        controller: controller.homeserverController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: controller.state == HomeserverState.wrongServerName
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 2.0,
                  ),
                )
              : null,
          labelText: controller.state != HomeserverState.wrongServerName
              ? L10n.of(context)!.homeserver
              : L10n.of(context)!.wrongServerName,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 0.4,
                color: controller.state != HomeserverState.wrongServerName
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.error,
              ),
          hintText: L10n.of(context)!.enterYourHomeserver,
          contentPadding: const EdgeInsets.all(16.0),
        ),
      ),
      itemBuilder: (BuildContext context, HomeserverBenchmarkResult server) {
        return ListTile(
          trailing: IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: Colors.black,
            ),
            onPressed: () => controller.showServerInfo(server),
          ),
          title: Text(
            server.homeserver.baseUrl.host,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            server.homeserver.description ?? '',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        );
      },
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        constraints: BoxConstraints(maxHeight: 200),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      debounceDuration: const Duration(milliseconds: 300),
      direction: AxisDirection.up,
      onSuggestionSelected: (HomeserverBenchmarkResult suggestion) {
        controller.setServer(suggestion.homeserver.baseUrl.host);
      },
      suggestionsCallback: (String searchTerm) async {
        if (benchmarkResults == null) {
          controller.loadHomeserverList();
        }
        return controller.filteredHomeservers(searchTerm);
      },
      hideOnError: true,
      hideOnEmpty: true,
      hideOnLoading: true,
    );
  }
}
