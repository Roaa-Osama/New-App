import 'package:flutter/material.dart';

class AppSnack {
  static void success(BuildContext context, String msg) {
    _show(context, msg, isError: false);
  }

  static void error(BuildContext context, String msg) {
    _show(context, msg, isError: true);
  }

  static void _show(BuildContext context, String msg, {required bool isError}) {
    final bg = isError ? const Color(0xFFB42318) : const Color(0xFF027A48);
    final icon = isError ? Icons.error_rounded : Icons.check_circle_rounded;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}