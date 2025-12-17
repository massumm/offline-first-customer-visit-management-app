import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/modules/app_settings/models/unit_setting_model.dart';
import 'package:icon/app/modules/app_settings/models/active_device_model.dart';
import 'package:icon/app/modules/app_settings/models/radio_button_option.dart';

class AppSettingsController extends BaseController {
  //TODO: Implement AppSettingsController

  final count = 0.obs;

  // Region & Language
  final selectedTimezone = 'America/New_York'.obs;
  final selectedLanguage = 'English'.obs;

  final timeZoneList = [
    'America/New_York',
    'America/Los_Angeles',
    'Europe/London',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  final languageList = ['English'];

  // Text Size Options
  final textSizeList = [
    RadioButtonOption(
      title: 'Small',
      textStyle: AppTextTheme.bodyMediumRegular, //12px medium, black
    ),
    RadioButtonOption(
      title: 'Medium (Default)',
      textStyle: AppTextTheme.bodyLargeRegular, //14px medium, black
    ),
    RadioButtonOption(
      title: 'Large',
      textStyle: AppTextTheme.titleSmallRegular, //16px medium, black
    ),
    RadioButtonOption(
      title: 'Extra Large',
      textStyle: AppTextTheme.titleMediumRegular, //18px medium, black
    ),
  ];

  // Units & Preferences
  final selectedDistance = 'Kilometers (km)'.obs;
  final selectedWeight = 'Kilograms (kg)'.obs;
  final selectedHeight = 'Centimeter (cm)'.obs;
  final selectedTemperature = 'Celsius (°C)'.obs;
  final is24HourFormat = false.obs;
  final isWeekStartMonday = false.obs;

  // Accessibility
  final highContrastMode = false.obs;
  final reduceMotion = false.obs;
  final boldText = false.obs;

  // Temporary variables for unsaved changes
  final tempSelectedDistance = 'Kilometers (km)'.obs;
  final tempSelectedWeight = 'Kilograms (kg)'.obs;
  final tempSelectedHeight = 'Centimeter (cm)'.obs;
  final tempSelectedTemperature = 'Celsius (°C)'.obs;
  final tempIs24HourFormat = false.obs;
  final tempIsWeekStartMonday = false.obs;

  // Temporary accessibility variables
  final tempHighContrastMode = false.obs;
  final tempReduceMotion = false.obs;
  final tempBoldText = false.obs;
  final tempSelectedTextSize = 'Medium (Default)'.obs;

  // Temporary privacy variables
  final tempPublicProfile = false.obs;
  final tempShowActivities = false.obs;
  final tempShowStatistics = false.obs;
  final tempAllowMessages = false.obs;
  final tempShareLocationData = false.obs;
  final tempAnalyticsData = false.obs;

  final distanceList = ['Kilometers (km)', 'Miles (mi)'];
  final weightList = ['Kilograms (kg)', 'Pounds (lbs)', 'Stone (st)'];
  final heightList = ['Centimeter (cm)', 'Inches (in)'];
  final temperatureList = ['Celsius (°C)', 'Fahrenheit (°F)'];

  // Active Devices
  final activeDeviceList = <ActiveDevice>[
    ActiveDevice(
      deviceName: 'iPhone 14 Pro',
      deviceType: DeviceTypeEnum.mobile,
      osType: OsTypeEnum.ios,
      sessionStatus: SessionStatusEnum.active,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ActiveDevice(
      deviceName: 'MacBook Pro',
      deviceType: DeviceTypeEnum.laptop,
      osType: OsTypeEnum.macOs,
      sessionStatus: SessionStatusEnum.active,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ActiveDevice(
      deviceName: 'MacBook Pro',
      deviceType: DeviceTypeEnum.laptop,
      osType: OsTypeEnum.ios,
      sessionStatus: SessionStatusEnum.notUsedRecently,
      lastActive: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ].obs;

  // Feedback Types
  final feedbackTypeList = [
    RadioButtonOption(
      title: 'Feature request',
      textStyle: AppTextTheme.bodyLargeRegular,
    ),
    RadioButtonOption(
      title: 'Bug report',
      textStyle: AppTextTheme.bodyLargeRegular,
    ),
    RadioButtonOption(
      title: 'Improvement suggestion',
      textStyle: AppTextTheme.bodyLargeRegular,
    ),
    RadioButtonOption(title: 'Other', textStyle: AppTextTheme.bodyLargeRegular),
  ];

  final selectedFeedbackType = 'Feature request'.obs;

  // FAQ Expansion States
  final faqExpansionStates = <bool>[].obs;

  // Export Selection States
  final exportSelectionStates = <bool>[].obs;
  final allExportSelected = false.obs;

  // Delete Account Confirmation
  final deleteConfirmationText = ''.obs;
  final canDeleteAccount = false.obs;
  final deleteAccountAcknowledged = false.obs;

  // App Integration Connection States
  final integrationConnectionStates = <String, bool>{}.obs;
  final integrationLoadingStates = <String, bool>{}.obs;

  List<UnitSettingModel> get unitSettings => [
    UnitSettingModel(
      title: 'Distance',
      description: 'Choose your preferred distance measurement',
      items: distanceList,
      selectedValue: tempSelectedDistance,
    ),
    UnitSettingModel(
      title: 'Weight',
      description: 'Choose your preferred weight measurement',
      items: weightList,
      selectedValue: tempSelectedWeight,
    ),
    UnitSettingModel(
      title: 'Height',
      description: 'Choose your preferred height measurement',
      items: heightList,
      selectedValue: tempSelectedHeight,
    ),
    UnitSettingModel(
      title: 'Temperature',
      description: 'Choose your preferred temperature unit',
      items: temperatureList,
      selectedValue: tempSelectedTemperature,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize temporary variables with current saved values
    resetTempValues();
  }



  void increment() => count.value++;

  void savePreferences() {
    // Copy temporary values to main variables
    selectedDistance.value = tempSelectedDistance.value;
    selectedWeight.value = tempSelectedWeight.value;
    selectedHeight.value = tempSelectedHeight.value;
    selectedTemperature.value = tempSelectedTemperature.value;
    is24HourFormat.value = tempIs24HourFormat.value;
    isWeekStartMonday.value = tempIsWeekStartMonday.value;

    // Copy accessibility temporary values to main variables
    highContrastMode.value = tempHighContrastMode.value;
    reduceMotion.value = tempReduceMotion.value;
    boldText.value = tempBoldText.value;

    // TODO: Add persistence logic here (SharedPreferences, API, etc.)
    print('Preferences saved:');
    print('Distance: ${selectedDistance.value}');
    print('Weight: ${selectedWeight.value}');
    print('Height: ${selectedHeight.value}');
    print('Temperature: ${selectedTemperature.value}');
    print('24-Hour Format: ${is24HourFormat.value}');
    print('Week Start Monday: ${isWeekStartMonday.value}');
    print('High Contrast Mode: ${highContrastMode.value}');
    print('Reduce Motion: ${reduceMotion.value}');
    print('Bold Text: ${boldText.value}');
  }

  void resetTempValues() {
    // Reset temporary values to current saved values
    tempSelectedDistance.value = selectedDistance.value;
    tempSelectedWeight.value = selectedWeight.value;
    tempSelectedHeight.value = selectedHeight.value;
    tempSelectedTemperature.value = selectedTemperature.value;
    tempIs24HourFormat.value = is24HourFormat.value;
    tempIsWeekStartMonday.value = isWeekStartMonday.value;

    // Reset accessibility temporary values to current saved values
    tempHighContrastMode.value = highContrastMode.value;
    tempReduceMotion.value = reduceMotion.value;
    tempBoldText.value = boldText.value;
  }

  void removeDevice(ActiveDevice device) {
    activeDeviceList.remove(device);
  }

  void toggleFaqExpansion(int index) {
    if (index >= 0 && index < faqExpansionStates.length) {
      faqExpansionStates[index] = !faqExpansionStates[index];
    }
  }

  void initializeFaqExpansionStates(int length) {
    if (faqExpansionStates.length != length) {
      faqExpansionStates.assignAll(List.filled(length, false));
    }
  }

  void toggleExportSelection(int index) {
    if (index >= 0 && index < exportSelectionStates.length) {
      exportSelectionStates[index] = !exportSelectionStates[index];
      updateAllExportSelected();
    }
  }

  void toggleAllExportSelections() {
    final newValue = !allExportSelected.value;
    exportSelectionStates.assignAll(
      List.filled(exportSelectionStates.length, newValue),
    );
    allExportSelected.value = newValue;
  }

  void updateAllExportSelected() {
    allExportSelected.value = exportSelectionStates.every(
      (selected) => selected,
    );
  }

  void initializeExportSelectionStates() {
    const categoryCount = 6; // Number of export categories
    if (exportSelectionStates.length != categoryCount) {
      exportSelectionStates.assignAll(List.filled(categoryCount, false));
      updateAllExportSelected();
    }
  }

  void updateDeleteConfirmation(String value) {
    deleteConfirmationText.value = value;
    canDeleteAccount.value =
        value.trim() == 'DELETE' && deleteAccountAcknowledged.value;
  }

  void toggleDeleteAccountAcknowledgment() {
    deleteAccountAcknowledged.value = !deleteAccountAcknowledged.value;
    canDeleteAccount.value =
        deleteConfirmationText.value.trim() == 'DELETE' &&
        deleteAccountAcknowledged.value;
  }

  Future<bool> deleteAccount() async {
    try {
      // TODO: Implement actual API call to delete account
      // For now, simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // Clear local data and tokens
      // TODO: Add actual data clearing logic
      // await _clearUserData();
      // await _clearTokens();

      return true; // Simulate successful deletion
    } catch (e) {
      // Log error and return failure
      print('Error deleting account: $e');
      return false;
    }
  }

  void initializeIntegrationStates() {
    // Initialize default connection states for integrations
    const integrations = [
      'Google Fit',
      'Apple Health',
      'Fitbit',
      'Garmin Connect',
    ];
    for (final integration in integrations) {
      integrationConnectionStates[integration] = false;
      integrationLoadingStates[integration] = false;
    }
  }

  Future<void> toggleIntegrationConnection(String integrationName) async {
    integrationLoadingStates[integrationName] = true;

    try {
      // TODO: Implement actual integration connection/disconnection logic
      // For now, simulate API call with delay
      await Future.delayed(const Duration(seconds: 2));

      // Toggle connection state
      final currentState =
          integrationConnectionStates[integrationName] ?? false;
      integrationConnectionStates[integrationName] = !currentState;

      // Show success message
      final action = !currentState ? 'connected' : 'disconnected';
      Get.snackbar(
        'Success',
        '$integrationName has been $action',
        backgroundColor: AppColors.colorPrimary,
        colorText: Colors.white,
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to connect to $integrationName. Please try again.',
        backgroundColor: AppColors.warningBgColor,
        colorText: Colors.white,
      );
    } finally {
      integrationLoadingStates[integrationName] = false;
    }
  }
}
