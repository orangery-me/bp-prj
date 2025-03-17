import 'package:blood_pressure/common/extensions/data_analyze_extension.dart';
import 'package:blood_pressure/common/enums/bp_status.dart';
import 'package:flutter/material.dart';

class BpAnalyzeBox extends StatelessWidget {
  final int systolis;
  final int diastolis;
  final Color? color;
  final double? iconSize;
  final double? fontSize;

  const BpAnalyzeBox({
    super.key,
    required this.systolis,
    required this.diastolis,
    this.color,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    int bpStatus = DataAnalyzeExtension.getBPStatus(systolis, diastolis);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: BpStatus.values[bpStatus].color,
              borderRadius: BorderRadius.circular(4)),
          padding: EdgeInsets.all(iconSize ?? 3),
          child: const Icon(Icons.circle, color: Colors.white, size: 6),
        ),
        const SizedBox(width: 4),
        Text(
          BpStatus.values[bpStatus].status,
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: fontSize ?? 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
