import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

class HomeController extends JController {
  // ...
  void showMaterialAlertDialog() {
    JDialog.materialAlertDialog(
      title: const Text('Alert'),
      content: const Text('Modal content...'),
      confirmLabel: const Text('OK'),
      onConfirm: () {},
      barrierDismissible: true,
    );
  }

  // ...
  void showCupertinoAlertDialog() {
    JDialog.cupertinoAlertDialog(
      title: const Text('Alert'),
      content: const Text('Modal content...'),
      confirmLabel: const Text('OK'),
      onConfirm: () {},
      barrierDismissible: true,
    );
  }

  // ...
  void showMaterialConfirmDialog() {
    JDialog.materialConfirmationDialog(
      title: const Text('Confirm'),
      content: const Text('Modal content...'),
      confirmLabel: const Text('OK'),
      cancelLabel: const Text('Cancel'),
      onConfirm: () {},
      onCancel: () {},
      barrierDismissible: true,
    );
  }

  // ...
  void showCupertinoConfirmDialog() {
    JDialog.cupertinoConfirmationDialog(
      title: const Text('Confirm'),
      content: const Text('Modal content...'),
      confirmLabel: const Text('OK'),
      cancelLabel: const Text('Cancel'),
      onConfirm: () {},
      onCancel: () {},
      barrierDismissible: true,
    );
  }

  // ...
  void showMaterialActionSheet() {
    JDialog.materialActionSheet(
      actions: [
        ListTile(
          title: const Text('New'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Open'),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Save'),
          onTap: () {},
        ),
      ],
      cancelButton: ListTile(
        title: const Text('Cancel', style: TextStyle(color: Colors.red)),
        onTap: () {},
      ),
    );
  }

  void showCupertinoActionSheet() {
    JDialog.cupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: const Text('New'),
          onPressed: () {},
        ),
        CupertinoActionSheetAction(
          child: const Text('Open'),
          onPressed: () {},
        ),
        CupertinoActionSheetAction(
          child: const Text('Save'),
          onPressed: () {},
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        onPressed: () {},
      ),
    );
  }

  void showMaterialSnackBar() {
    JDialog.snackBar(
      content: const Text('Modal content...'),
      actionLabel: 'OK',
      onAction: () {},
    );
  }

  // ...
}
