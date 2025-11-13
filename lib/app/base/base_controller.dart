import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../flavors/build_config.dart';
import 'models/app_states.dart';

abstract class BaseController extends GetxController
    with WidgetsBindingObserver {
  final Logger logger = BuildConfig.instance.config.logger;

  /// Reload the page
  final _refreshController = false.obs;
  bool refreshPage(bool refresh) => _refreshController(refresh);
  //Controls page state
  final _pageSateController = PageState.DEFAULT.obs;
  PageState get pageState => _pageSateController.value;
  PageState updatePageState(PageState state) => _pageSateController(state);
  PageState resetPageState() => _pageSateController(PageState.DEFAULT);
  dynamic showLoading() => updatePageState(PageState.LOADING);
  dynamic showSuccess() => updatePageState(PageState.SUCCESS);
  dynamic showFailed() => updatePageState(PageState.FAILED);
  dynamic showUpdated() => updatePageState(PageState.UPDATED);
  dynamic showCreated() => updatePageState(PageState.CREATED);
  dynamic showNoInternet() => updatePageState(PageState.NO_INTERNET);
  dynamic showMessagePage() => updatePageState(PageState.MESSAGE);
  dynamic showUnauthorized() => updatePageState(PageState.UNAUTHORIZED);
  dynamic showChannelSwitchLoading() =>
      updatePageState(PageState.CHANNEL_TRANSITION_LOADING);

  dynamic hideLoading() => resetPageState();
  final _messageController = ''.obs;
  String get message => _messageController.value;
  String showMessage(String msg) => _messageController(msg);
  final _errorMessageController = ''.obs;
  String get networkErrorMsg => _errorMessageController.value;
  String showErrorMessage(String msg) => _errorMessageController(msg);
  final _successMessageController = ''.obs;
  String get successMessage => _messageController.value;
  String showSuccessMessage(String msg) => _successMessageController(msg);

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    _messageController.close();
    _refreshController.close();
    _pageSateController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
