import 'package:flutter/material.dart';
import '../../utils/color_manager.dart';
import '../../utils/styles_manager.dart';
import '../../utils/values_manager.dart';

class LoadingOverlay extends StatelessWidget {
  final bool visible;
  final String? message;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.visible,
    this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: AbsorbPointer(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: ColorManager.primary),
                        if (message != null) ...[
                          const SizedBox(height: AppSize.s16),
                          Text(
                            message!,
                            style: getRegularStyle(
                              color: ColorManager.textPrimary,
                              fontSize: AppSize.s14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
