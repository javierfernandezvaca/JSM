import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../jrouter/jrouter.dart';
import '../jrouter/jrouter_observer.dart';

enum JDialogMode { material, cupertino }

class JDialog {
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final BuildContext _context =
      JRouter.navigatorKey.currentState!.context;

  // ...

  static void snackBar({
    required Widget content,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: content,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onAction,
              )
            : null,
        duration: duration,
      ),
    );
  }

  // ...

  static Future<T?> materialAlertDialog<T>({
    required Widget title,
    Widget? content,
    Widget confirmLabel = const Text('OK'),
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: confirmLabel,
            ),
          ],
        );
      },
      routeSettings: const NamedRouteSettings(name: 'AlertDialog Modal'),
    );
  }

  static Future<T?> cupertinoAlertDialog<T>({
    required Widget title,
    Widget? content,
    List<Widget> actions = const <Widget>[],
    Widget confirmLabel = const Text('OK'),
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
  }) {
    return showCupertinoDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              child: confirmLabel,
            ),
          ],
        );
      },
      routeSettings:
          const NamedRouteSettings(name: 'CupertinoAlertDialog Modal'),
    );
  }

  // ...

  static Future<T?> materialConfirmationDialog<T>({
    required Widget title,
    Widget? content,
    Widget confirmLabel = const Text('Confirm'),
    Widget cancelLabel = const Text('Cancel'),
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            TextButton(
              child: confirmLabel,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
            ),
            TextButton(
              child: cancelLabel,
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
            ),
          ],
        );
      },
      routeSettings:
          const NamedRouteSettings(name: 'MaterialConfirmationDialog Modal'),
    );
  }

  static Future<T?> cupertinoConfirmationDialog<T>({
    required Widget title,
    Widget? content,
    Widget confirmLabel = const Text('Confirm'),
    Widget cancelLabel = const Text('Cancel'),
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showCupertinoDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            CupertinoDialogAction(
              child: confirmLabel,
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
            ),
            CupertinoDialogAction(
              child: cancelLabel,
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
            ),
          ],
        );
      },
      routeSettings:
          const NamedRouteSettings(name: 'CupertinoConfirmationDialog Modal'),
    );
  }

  // ...

  static ListTile _cloneListTile(ListTile original, VoidCallback onTap) {
    return ListTile(
      key: original.key,
      leading: original.leading,
      title: original.title,
      subtitle: original.subtitle,
      trailing: original.trailing,
      isThreeLine: original.isThreeLine,
      dense: original.dense,
      visualDensity: original.visualDensity,
      shape: original.shape,
      style: original.style,
      selectedColor: original.selectedColor,
      iconColor: original.iconColor,
      textColor: original.textColor,
      contentPadding: original.contentPadding,
      enabled: original.enabled,
      onTap: onTap,
      onLongPress: original.onLongPress,
      mouseCursor: original.mouseCursor,
      selected: original.selected,
      focusColor: original.focusColor,
      hoverColor: original.hoverColor,
      focusNode: original.focusNode,
      autofocus: original.autofocus,
      tileColor: original.tileColor,
      selectedTileColor: original.selectedTileColor,
      enableFeedback: original.enableFeedback,
      horizontalTitleGap: original.horizontalTitleGap,
      minVerticalPadding: original.minVerticalPadding,
      minLeadingWidth: original.minLeadingWidth,
    );
  }

  static Future<T?> materialActionSheet<T>({
    required List<ListTile> actions,
    ListTile? cancelButton,
  }) {
    return showModalBottomSheet<T>(
      context: _context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...actions.map((action) {
                  return _cloneListTile(action, () {
                    Navigator.of(context).pop();
                    action.onTap?.call();
                  });
                }),
                if (cancelButton != null)
                  _cloneListTile(cancelButton, () {
                    Navigator.of(context).pop();
                    cancelButton.onTap?.call();
                  }),
              ],
            ),
          ),
        );
      },
      routeSettings:
          const NamedRouteSettings(name: 'MaterialActionSheet Modal'),
    );
  }

  static CupertinoActionSheetAction _cloneCupertinoActionSheetAction(
    CupertinoActionSheetAction original,
    VoidCallback onPressed,
  ) {
    return CupertinoActionSheetAction(
      key: original.key,
      onPressed: onPressed,
      isDefaultAction: original.isDefaultAction,
      isDestructiveAction: original.isDestructiveAction,
      child: original.child,
    );
  }

  static Future<T?> cupertinoActionSheet<T>({
    required List<CupertinoActionSheetAction> actions,
    CupertinoActionSheetAction? cancelButton,
  }) {
    return showCupertinoModalPopup<T>(
      context: _context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: actions.map((action) {
            return _cloneCupertinoActionSheetAction(action, () {
              Navigator.of(context).pop();
              action.onPressed();
            });
          }).toList(),
          cancelButton: cancelButton != null
              ? _cloneCupertinoActionSheetAction(cancelButton, () {
                  Navigator.of(context).pop();
                  cancelButton.onPressed();
                })
              : null,
        );
      },
      routeSettings:
          const NamedRouteSettings(name: 'CupertinoActionSheet Modal'),
    );
  }

  // ...

  static Future<T?> customDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          child: child,
        );
      },
      routeSettings: const NamedRouteSettings(name: 'CustomDialog Modal'),
    );
  }

  // ...
}
