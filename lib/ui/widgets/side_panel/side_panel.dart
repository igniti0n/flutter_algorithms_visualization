import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_finding/ui/colors.dart';
import 'package:path_finding/ui/widgets/side_panel/reset_button.dart';
import 'package:path_finding/ui/widgets/side_panel/sliders.dart';

class SidePanel extends ConsumerWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      color: AppColors.panelBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ResetButtons(),
            SizedBox(
              height: 20,
            ),
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
