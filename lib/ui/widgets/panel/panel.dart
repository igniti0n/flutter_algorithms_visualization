import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_finding/notifiers/is_panel_opened_provider.dart';
import 'package:path_finding/ui/widgets/panel/panel_body.dart';
import 'package:path_finding/ui/widgets/panel/panel_sliding.dart';

class Panel extends HookConsumerWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 350));
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -PanelBody.height),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    ref.listen<bool>(isPanelOpenedProvider, (_, isOpened) {
      if (isOpened) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) => Transform.translate(
        offset: offsetAnimation.value,
        child: child,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: PanelBody.height),
              child: const PanelBody(),
            ),
          ),
          Positioned(
            top: PanelBody.height,
            left: 44,
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: const SlidingPanel(),
            ),
          ),
        ],
      ),
    );
  }
}
