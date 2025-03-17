import 'package:flutter/cupertino.dart';


class PickerSizedBox extends StatelessWidget {
  final double width;
  final double height;
  final List<Widget> items;
  final FixedExtentScrollController controller;
  final ValueChanged<int> onSelectedItemChanged;
  final BorderRadiusGeometry? borderRadius;

  const PickerSizedBox({
    super.key,
    required this.width,
    required this.height,
    required this.items,
    required this.controller,
    required this.onSelectedItemChanged,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CupertinoPicker(
        selectionOverlay: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: const CupertinoPickerDefaultSelectionOverlay(
            capStartEdge: false,
            capEndEdge: false,
          ),
        ),
        scrollController: controller,
        itemExtent: 30,
        onSelectedItemChanged: onSelectedItemChanged,
        children: items,
      ),
    );
  }
}
