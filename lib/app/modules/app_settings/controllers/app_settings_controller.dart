import 'package:get/get.dart';
import 'package:icon/app/base/base_controller.dart';
import 'package:icon/app/modules/app_settings/models/unit_setting_model.dart';

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
  
  final distanceList = ['Kilometers (km)', 'Miles (mi)'];
  final weightList = ['Kilograms (kg)', 'Pounds (lbs)', 'Stone (st)'];
  final heightList = ['Centimeter (cm)', 'Inches (in)'];
  final temperatureList = ['Celsius (°C)', 'Fahrenheit (°F)'];
  
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
}
