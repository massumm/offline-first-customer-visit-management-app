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

abstract class BaseView<Controller extends BaseController>
    extends GetView<Controller> {
  BaseView({super.key});

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final Logger logger = BuildConfig.instance.config.logger;

  Widget body(BuildContext context);

  PreferredSizeWidget? appBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor(),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          bottom: true,
          top: false,
          child: Scaffold(
            key: globalKey,
            resizeToAvoidBottomInset: true,
            backgroundColor: pageBackgroundColor(),
            appBar: appBar(context),
            floatingActionButton: floatingActionButton(),
            floatingActionButtonLocation: floatingActionLocation,
            bottomNavigationBar: bottomNavigationBar(context),
            drawer: drawer(),
            body: Stack(
              children: [
                SafeArea(
                  child: body(context),
                ),
                Obx(() => controller.pageState == PageState.LOADING
                    ? _showLoading()
                    : const SizedBox.shrink()),
                Obx(() => controller.pageState == PageState.CHANNEL_TRANSITION_LOADING
                    ? _showChannelSwitchLoading()
                    : const SizedBox.shrink()),
                Obx(() => controller.errorMessage.isNotEmpty
                    ? showErrorSnackBar(controller.errorMessage)
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    });
    return const SizedBox.shrink();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  Color pageBackgroundColor() => AppColors.pageBackground;

  Color statusBarColor() => AppColors.pageBackground;

  Widget? floatingActionButton() => null;

  FloatingActionButtonLocation? get floatingActionLocation => null;

  Widget? bottomNavigationBar(BuildContext context) => null;

  Widget? drawer() => null;

   Widget _showLoading() => const Loading();
   Widget _showChannelSwitchLoading() => const ChannelTransitionLoader();
}
