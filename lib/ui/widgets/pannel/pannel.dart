import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_finding/notifiers/is_pannel_opened_provider.dart';
import 'package:path_finding/ui/widgets/pannel/pannel_body.dart';
import 'package:path_finding/ui/widgets/pannel/pannel_pully.dart';

class Pannel extends HookConsumerWidget {
  const Pannel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 350));
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -PannelBody.height),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    ref.listen<bool>(isPannelOpenedProvider, (_, isOpened) {
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
              constraints: const BoxConstraints(maxHeight: PannelBody.height),
              child: const PannelBody(),
            ),
          ),
          Positioned(
            top: PannelBody.height,
            left: 44,
            child: Transform.translate(
              offset: const Offset(0, -16),
              child: const PannelPully(),
            ),
          ),
        ],
      ),
    );
  }
}
