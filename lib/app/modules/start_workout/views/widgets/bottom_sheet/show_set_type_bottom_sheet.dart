import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> showSetTypeBottomSheet(BuildContext context) async {
  final theme = Theme.of(context);
 return await showModalBottomSheet(
    context: context,
    backgroundColor: theme.colorScheme.surfaceContainerHighest,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) {
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
            _buildSetTypeOption(
              context: context,
              label: "Warm Up Set",
              leading: const Text(
                "W",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              showInfo: true,
              onTap: () {
                Get.back(result: 'W');
              },
            ),

            _buildSetTypeOption(
              context: context,
              label: "Normal Set",
              leading: const Text(
                "1",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              showInfo: true,
              onTap: () {
                Get.back(result: '1');
              },
            ),

            _buildSetTypeOption(
              context: context,
              label: "Failure Set",
              leading: const Text(
                "F",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              showInfo: true,
              onTap: () {
                Get.back(result: 'F');
              },
            ),

            _buildSetTypeOption(
              context: context,
              label: "Drop Set",
              leading: const Text(
                "D",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              showInfo: true,
              onTap: () {
                Get.back(result: 'D');
              },
            ),

            _buildSetTypeOption(
              context: context,
              label: "Remove Set",
              leading: const Icon(
                Icons.close,
                color: Colors.redAccent,
                size: 20,
              ),
              showInfo: false,
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
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

                // Label
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Info Icon (Right side)
                if (showInfo)
                  const Icon(Icons.help_outline, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
      // Thin divider
      const Divider(
        height: 1,
        color: Colors.white10,
        indent: 16,
        endIndent: 16,
      ),
    ],
  );
}
