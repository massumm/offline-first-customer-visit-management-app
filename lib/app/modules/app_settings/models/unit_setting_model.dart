import 'package:get/get.dart';

class UnitSettingModel {
  final String title;
  final String description;
  final List<String> items;
  final RxString selectedValue;

  UnitSettingModel({
    required this.title,
    required this.description,
    required this.items,
    required this.selectedValue,
  });
}
