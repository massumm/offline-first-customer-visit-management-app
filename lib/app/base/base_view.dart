import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../core/values/app_colors.dart';
import '../flavors/build_config.dart';
import 'base_controller.dart';
import 'models/app_states.dart';
import 'widgets/channel_switching_loading.dart';
import 'widgets/loading.dart';

/// Adaptive BaseView:
/// - Android/others -> Material Scaffold (your current behavior)
/// - iOS -> CupertinoPageScaffold with CupertinoNavigationBar
abstract class BaseView<Controller extends BaseController>
    extends GetView<Controller> {
  BaseView({super.key});

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final Logger logger = BuildConfig.instance.config.logger;

  /// Common body for both platforms
  Widget body(BuildContext context);

  /// Material app bar (Android)
  PreferredSizeWidget? appBar(BuildContext context) => null;

  /// Cupertino navigation bar (iOS)
  CupertinoNavigationBar? cupertinoNavigationBar(BuildContext context) => null;

  /// Material-only
  Widget? floatingActionButton() => null;

  FloatingActionButtonLocation? get floatingActionLocation => null;

  Widget? bottomNavigationBar(BuildContext context) => null;

  Widget? drawer() => null;

  /// Colors
  /// The background color for the page. Defaults to the theme's scaffold color.
  /// Override in subclasses for custom page colors.
  Color pageBackgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  /// The color of the system status bar. Defaults to the page background color
  /// for a seamless look. The icon brightness is handled automatically.
  Color statusBarColor(BuildContext context) => pageBackgroundColor(context);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertino(context)
        : _buildMaterial(context);
  }

  /// —————————————————————
  /// Material (Android)
  /// —————————————————————
  Widget _buildMaterial(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor(context),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            key: globalKey,
            resizeToAvoidBottomInset: true,
            backgroundColor: pageBackgroundColor(context),
            appBar: appBar(context),
            floatingActionButton: floatingActionButton(),
            floatingActionButtonLocation: floatingActionLocation,
            bottomNavigationBar: bottomNavigationBar(context),
            drawer: drawer(),
            body: Stack(
              children: [
                SafeArea(child: body(context)),
                Obx(
                  () => controller.pageState == PageState.LOADING
                      ? _showLoading()
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () =>
                      controller.pageState ==
                          PageState.CHANNEL_TRANSITION_LOADING
                      ? _showChannelSwitchLoading()
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () => controller.errorMessage.isNotEmpty
                      ? _showErrorSnackBar(controller.errorMessage)
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

    // On iOS, status bar uses *opposite* icon brightness than background.
    final overlay = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlay,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          navigationBar: cupertinoNavigationBar(context),
          child: Stack(
            children: [
              // CupertinoPageScaffold already handles top padding with a nav bar,
              // but SafeArea keeps bottom insets tidy.
              SafeArea(bottom: true, child: body(context)),
              Obx(
                () => controller.pageState == PageState.LOADING
                    ? _showCupertinoLoading()
                    : const SizedBox.shrink(),
              ),
              Obx(
                () =>
                    controller.pageState == PageState.CHANNEL_TRANSITION_LOADING
                    ? _showChannelSwitchLoading()
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => controller.errorMessage.isNotEmpty
                    ? _showCupertinoError(controller.errorMessage)
                    : const SizedBox.shrink(),
              ),
              // If you really want a FAB on iOS, position it manually:
              // if (floatingActionButton() != null)
              //   Positioned(
              //     right: 16, bottom: 16, child: floatingActionButton()!,
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  /// —————————————————————
  /// Error & Loading helpers
  /// —————————————————————

  /// Material snackbar
  Widget _showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = Get.context;
      if (ctx != null) ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
    });
    return const SizedBox.shrink();
  }

  /// Cupertino alert
  Widget _showCupertinoError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctx = Get.context;
      if (ctx == null) return;
      await showCupertinoDialog(
        context: ctx,
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

  /// Your existing loaders (kept)
  Widget _showLoading() => const Loading();

  Widget _showChannelSwitchLoading() => const ChannelTransitionLoader();

  /// Native iOS spinner (optional; use your Loading() if it’s platform-agnostic)
  Widget _showCupertinoLoading() =>
      const Center(child: CupertinoActivityIndicator());

  /// Shared toast
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }
}
