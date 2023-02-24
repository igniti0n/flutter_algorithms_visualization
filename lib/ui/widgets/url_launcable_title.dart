import 'package:flutter/material.dart';
import 'package:path_finding/ui/common/text/unit_rounded_text.dart';

class UrlLaunchableTitle extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const UrlLaunchableTitle({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return ContinuousRectangleBorder(
                  side: BorderSide(color: Colors.grey.withOpacity(0.8)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)));
            }

            return const ContinuousRectangleBorder(
                side: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(10)));
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return Colors.black; // Defer to the widget's default.
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.blue.withOpacity(0.8);
            }

            return Colors.transparent; // De/ Defer to the widget's default.
          },
        ),
      ),
      onPressed: onPressed,
      child: UnitRoundedText(
        text,
        color: Colors.black,
        fontSize: 18,
        underline: true,
      ),
    );
  }
}
