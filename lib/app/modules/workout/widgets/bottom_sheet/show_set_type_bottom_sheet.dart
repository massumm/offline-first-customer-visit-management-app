import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum SetType { warmUp, normal, failure, drop, remove }

extension SetTypeProperties on SetType {
  String get label {
    switch (this) {
      case SetType.warmUp:
        return "Warm Up Set";
      case SetType.normal:
        return "Normal Set";
      case SetType.failure:
        return "Failure Set";
      case SetType.drop:
        return "Drop Set";
      case SetType.remove:
        return "Remove Set";
    }
  }

  String get shortLabel {
    switch (this) {
      case SetType.warmUp:
        return "W";
      case SetType.normal:
        return "N";
      case SetType.failure:
        return "F";
      case SetType.drop:
        return "D";
      case SetType.remove:
        return "R";
    }
  }

  // Get color
  Color get color {
    switch (this) {
      case SetType.warmUp:
        return Colors.amber;
      case SetType.normal:
        return Colors.grey;
      case SetType.failure:
        return Colors.redAccent;
      case SetType.drop:
        return Colors.blue;
      case SetType.remove:
        return Colors.redAccent;
    }
  }

  Widget get leading {
    final style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    switch (this) {
      case SetType.warmUp:
        return Text("W", style: style.copyWith(color: Colors.amber));
      case SetType.normal:
        return Text("1", style: style.copyWith(color: Colors.white));
      case SetType.failure:
        return Text("F", style: style.copyWith(color: Colors.redAccent));
      case SetType.drop:
        return Text("D", style: style.copyWith(color: Colors.blue));
      case SetType.remove:
        return const Icon(Icons.close, color: Colors.redAccent, size: 20);
    }
  }

  bool get isDestructive => this == SetType.remove;

  bool get showInfo => this != SetType.remove;
}

Future<SetType?> showSetTypeBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
  return await showModalBottomSheet<SetType>(
    context: context,
    backgroundColor: theme.colorScheme.surfaceContainerHighest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
      final standardOptions = SetType.values
          .where((t) => t != SetType.remove)
          .toList();
      final removeOption = SetType.remove;

      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Set Type",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white10),

            ...standardOptions.map(
              (setType) => _buildSetTypeOption(
                context: context,
                label: setType.label,
                leading: setType.leading,
                showInfo: setType.showInfo,
                onTap: () {
                  Get.back(result: setType);
                },
              ),
            ),

            _buildSetTypeOption(
              context: context,
              label: removeOption.label,
              leading: removeOption.leading,
              showInfo: removeOption.showInfo,
              isDestructive: removeOption.isDestructive,
              onTap: () {
                Get.back(result: removeOption);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildSetTypeOption({
  required BuildContext context,
  required String label,
  required Widget leading,
  required VoidCallback onTap,
  bool showInfo = true,
  bool isDestructive = false,
}) {
  final labelColor = isDestructive ? Colors.redAccent : Colors.white;

  return Column(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Align(alignment: Alignment.centerLeft, child: leading),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showInfo)
                  const Icon(Icons.help_outline, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
      const Divider(
        height: 1,
        color: Colors.white10,
        indent: 16,
        endIndent: 16,
      ),
    ],
  );
}
