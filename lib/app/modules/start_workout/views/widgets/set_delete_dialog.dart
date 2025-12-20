// in /Users/smh/Development/apps/Icon/lib/app/modules/start_workout/views/widgets/set_delete_dialog.dart

import 'package:flutter/material.dart';

// Modify the function to return a Future<bool?> and remove the onDeletePressed callback.
Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onDelete,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('DELETE'),
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete();
            },
          ),
        ],
      );
    },
  );
}
