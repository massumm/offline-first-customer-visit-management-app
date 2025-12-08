import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../flavors/build_config.dart';
import 'base_controller.dart';
import 'models/app_states.dart';
import 'widgets/channel_switching_loading.dart';
import 'widgets/loading.dart';

/// Adaptive BaseView:
/// A stateless, const-constructible class that defines the configuration for a page.
/// The actual stateful scaffold is built by a private helper widget.
abstract class BaseView<Controller extends BaseController>
    extends GetView<Controller> {
  const BaseView({super.key});

  /// The logger is now a getter, fetched at runtime when accessed.
  Logger get logger => BuildConfig.instance.config.logger;


  /// Common body for both platforms.
  Widget body(BuildContext context);

  /// Material app bar (Android).
  PreferredSizeWidget? appBar(BuildContext context) => null;

  /// Cupertino navigation bar (iOS).
  /// This should return a widget that implements [ObstructingPreferredSizeWidget],
  /// such as a [CupertinoNavigationBar].
  ObstructingPreferredSizeWidget? cupertinoNavigationBar(BuildContext context) => null;

  /// Material-only floating action button.
  Widget? floatingActionButton() => null;

  FloatingActionButtonLocation? get floatingActionLocation => null;

  Widget? bottomNavigationBar(BuildContext context) => null;

  Widget? drawer() => null;

  Color pageBackgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;


  /// The build method now delegates to a stateful helper widget.
  /// This allows the BaseView itself to be const while the underlying scaffold
  /// can manage state (like a GlobalKey).
  @override
  Widget build(BuildContext context) {
    return _BaseViewScaffold(view: this);
  }


  SystemUiOverlayStyle getMaterialOverlayStyle(BuildContext context) {
    final Color bgColor = pageBackgroundColor(context);
    final Brightness brightness = ThemeData.estimateBrightnessForColor(bgColor);
    final Brightness iconBrightness =
    brightness == Brightness.dark ? Brightness.light : Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: bgColor,
      statusBarIconBrightness: iconBrightness,
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  Widget _showLoading() => const Loading();
  Widget _showChannelSwitchLoading() => const ChannelTransitionLoader();
  Widget _showCupertinoLoading() =>
      const Center(child: CupertinoActivityIndicator());

//endregion
}

/// Internal StatefulWidget that builds the actual UI.
/// It holds the state (GlobalKey) and uses the `BaseView` as its configuration.
class _BaseViewScaffold<Controller extends BaseController>
    extends StatefulWidget {
  final BaseView<Controller> view;

  const _BaseViewScaffold({required this.view});

  @override
  State<_BaseViewScaffold<Controller>> createState() =>
      _BaseViewScaffoldState<Controller>();
}

class _BaseViewScaffoldState<Controller extends BaseController>
    extends State<_BaseViewScaffold<Controller>> {
  // The GlobalKey is now managed here, in the state object.
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  // Convenience getter for the controller.
  Controller get controller => widget.view.controller;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertino(context) : _buildMaterial(context);
  }

  /// —————————————————————
  /// Material (Android)
  /// —————————————————————
  Widget _buildMaterial(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: widget.view.getMaterialOverlayStyle(context),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            key: globalKey,
            resizeToAvoidBottomInset: true,
            backgroundColor: widget.view.pageBackgroundColor(context),
            appBar: widget.view.appBar(context),
            floatingActionButton: widget.view.floatingActionButton(),
            floatingActionButtonLocation: widget.view.floatingActionLocation,
            bottomNavigationBar: widget.view.bottomNavigationBar(context),
            drawer: widget.view.drawer(),
            body: Stack(
              children: [
                SafeArea(child: widget.view.body(context)),
                Obx(
                      () => controller.pageState == PageState.LOADING
                      ? widget.view._showLoading()
                      : const SizedBox.shrink(),
                ),
                Obx(
                      () => controller.pageState ==
                      PageState.CHANNEL_TRANSITION_LOADING
                      ? widget.view._showChannelSwitchLoading()
                      : const SizedBox.shrink(),
                ),
                Obx(
                      () => controller.networkErrorMsg.isNotEmpty
                      ? _showErrorSnackBar(controller.networkErrorMsg)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// —————————————————————
  /// Cupertino (iOS)
  /// —————————————————————
  Widget _buildCupertino(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final overlay =
    isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    final navigationBar = widget.view.cupertinoNavigationBar(context);
    final bottomNavBar = widget.view.bottomNavigationBar(context);

    // The main content stack, including overlays
    final Widget contentStack = Stack(
      children: [
        widget.view.body(context),
        Obx(
              () => controller.pageState == PageState.LOADING
              ? widget.view._showCupertinoLoading()
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.pageState == PageState.CHANNEL_TRANSITION_LOADING
              ? widget.view._showChannelSwitchLoading()
              : const SizedBox.shrink(),
        ),
        Obx(
              () => controller.networkErrorMsg.isNotEmpty
              ? _showCupertinoError(controller.networkErrorMsg)
              : const SizedBox.shrink(),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlay,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          navigationBar: navigationBar,
          child: Column(
            children: [
              // Body content expands to fill available space.
              Expanded(
                child: SafeArea(
                  top: navigationBar == null,
                  bottom: false,
                  child: contentStack,
                ),
              ),
              // The bottom navigation bar is placed here, outside the Expanded body.
              // It will now appear on iOS.
              if (bottomNavBar != null) bottomNavBar,
            ],
          ),
        ),
      ),
    );
  }

  /// —————————————————————
  /// Error & Loading helpers
  /// —————————————————————
  Widget _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    return const SizedBox.shrink();
  }

  Widget _showCupertinoError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showCupertinoDialog(
        context: context,
        builder: (c) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
    return const SizedBox.shrink();
  }
}
