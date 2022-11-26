import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/widgets/pannel/algorithm_button_picker.dart';
import 'package:path_finding/ui/widgets/pannel/reset_button.dart';
import 'package:path_finding/ui/widgets/pannel/sliders.dart';

class PannelBody extends ConsumerWidget {
  static const double height = 180;
  const PannelBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.panelBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(width: 20),
            ResetButtons(),
            SizedBox(width: 24),
            AlgorithmButtonPicker(),
            SizedBox(width: 24),
            DiagonalPathCostSlider(),
            SizedBox(
              height: 40,
            ),
            HorizontalAndVerticalPathCostSlider(),
          ],
        ),
      ),
    );
  }
}
