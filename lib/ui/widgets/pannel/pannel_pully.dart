import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/notifiers/is_pannel_opened_provider.dart';
import 'package:path_finding/ui/colors.dart';

class PannelPully extends ConsumerWidget {
  const PannelPully({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPannelOpened = ref.watch(isPannelOpenedProvider);

    return GestureDetector(
      onTap: () =>
          ref.read(isPannelOpenedProvider.notifier).state = !isPannelOpened,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.panelBackground,
          backgroundBlendMode: BlendMode.src,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        height: 58,
        width: 64,
        child: Icon(
          isPannelOpened
              ? Icons.arrow_drop_up_rounded
              : Icons.arrow_drop_down_rounded,
          size: 68,
        ),
      ),
    );
  }
}
