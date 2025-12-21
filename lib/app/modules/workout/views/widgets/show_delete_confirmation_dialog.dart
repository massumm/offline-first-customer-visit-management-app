import 'package:flutter/material.dart';

/// Shows a confirmation dialog for deletion.
///
/// If the user confirms, [onDelete] will be called after the dialog is dismissed.
///
/// Returns [true] if confirmed, [false] if cancelled/dismissed.
Future<bool> showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onDelete,
}) async {
  final theme = Theme.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: Text(
            'Delete',
            style: TextStyle(color: theme.colorScheme.error),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );

  if (result == true) {
    onDelete();
    return true;
  }
  return false;
}