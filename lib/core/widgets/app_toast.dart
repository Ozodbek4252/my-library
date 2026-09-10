import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'app_icons.dart';

/// The ink toast from the design: bottom-anchored, check icon, gone after
/// 2.4 seconds. Shown through the root overlay so it also floats above sheets
/// and dialogs.
abstract final class AppToast {
  static OverlayEntry? _current;
  static void Function()? _dismiss;

  static void show(
    BuildContext context,
    String message, {
    bool success = true,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _dismiss?.call();

    final entry = OverlayEntry(
      builder: (context) => _ToastBody(message: message, success: success),
    );
    _current = entry;
    overlay.insert(entry);

    var removed = false;
    void remove() {
      if (removed) return;
      removed = true;
      if (_current == entry) {
        _current = null;
        _dismiss = null;
      }
      entry.remove();
    }

    _dismiss = remove;
    Future<void>.delayed(AppMotion.toastLife).then((_) => remove());
  }
}

class _ToastBody extends StatefulWidget {
  const _ToastBody({required this.message, required this.success});

  final String message;
  final bool success;

  @override
  State<_ToastBody> createState() => _ToastBodyState();
}

class _ToastBodyState extends State<_ToastBody>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.rise,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Positioned(
      left: 20,
      right: 20,
      bottom: 104 + bottomInset * .2,
      child: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, .35),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: AppShadows.toast,
              ),
              child: Row(
                children: [
                  AppIcon(
                    widget.success ? AppIcons.check : AppIcons.alert,
                    size: 17,
                    color: widget.success
                        ? const Color(0xFFB5D0A8)
                        : AppColors.highlight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: AppText.sans(
                        size: 13.5,
                        weight: 500,
                        color: AppColors.paper,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
