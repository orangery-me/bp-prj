import 'package:blood_pressure/presentation/widgets/select_component/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectComponents extends StatefulWidget {
  final List<String> wholeNumbers;
  final List<String> fractions;
  final List<String> unit;
  final String type;
  final String initialWhole;
  final String initialFraction;
  final String initialUnit;
  final Function(Map<String, String>) onValueSelected;

  const SelectComponents({
    super.key,
    required this.type,
    required this.wholeNumbers,
    required this.fractions,
    required this.unit,
    required this.initialWhole,
    required this.initialFraction,
    required this.initialUnit,
    required this.onValueSelected,
  });

  @override
  State<SelectComponents> createState() => _SelectComponentsState();

  static showPicker(
    BuildContext context,
    List<String> wholeNumbers,
    List<String>? fractions,
    List<String> unit,
    String initialWhole,
    String initialFraction,
    String initialUnit,
    String type,
    Function(Map<String, String>) onSuffixChanged,
  ) {
    List<String> tmpFractions = fractions ?? [];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 450,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: SelectComponents(
                  wholeNumbers: wholeNumbers,
                  fractions: tmpFractions,
                  unit: unit,
                  type: type,
                  initialWhole: initialWhole,
                  initialFraction: initialFraction,
                  initialUnit: initialUnit,
                  onValueSelected: onSuffixChanged,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectComponentsState extends State<SelectComponents> {
  late int selectedWhole;
  late int selectedFraction;
  late int selectedUnit;

  @override
  void initState() {
    super.initState();
    selectedWhole = widget.wholeNumbers.indexOf(widget.initialWhole);
    selectedFraction = widget.fractions.indexOf(widget.initialFraction);
    selectedUnit = widget.unit.indexOf(widget.initialUnit);
  }

  List<Widget> _buildPickerItems(List<String> values, int selectedIndex) {
    return values.map<Widget>((value) {
      final bool isSelected = values.indexOf(value) == selectedIndex;
      return Center(
        child: Text(
          value,
          style: TextStyle(
            fontSize: isSelected ? 22 : 20,
            color: isSelected
                ? const Color(0xFF7F00FF)
                : CupertinoColors.inactiveGray,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPicker(
      double width,
      double height,
      List<String> items,
      int initialItem,
      Function(int) onChanged,
      BorderRadiusGeometry? borderRadius) {
    return PickerSizedBox(
      width: width,
      height: height,
      items: _buildPickerItems(items, initialItem),
      controller: FixedExtentScrollController(initialItem: initialItem),
      onSelectedItemChanged: onChanged,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 45, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Select your ${widget.type}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPicker(
                  100,
                  200,
                  widget.wholeNumbers,
                  selectedWhole,
                  (value) => setState(() => selectedWhole = value),
                  const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                _buildPicker(
                  80,
                  200,
                  widget.fractions,
                  selectedFraction,
                  (value) => setState(() => selectedFraction = value),
                  null,
                ),
                _buildPicker(
                  200,
                  200,
                  widget.unit,
                  selectedUnit,
                  (value) => setState(() => selectedUnit = value),
                  const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Container(
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE100FF), Color(0xFF7F00FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: CupertinoButton(
                child:
                    const Text('Done', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  String wholeNum = widget.wholeNumbers[selectedWhole];
                  String frac = widget.fractions.isNotEmpty
                      ? widget.fractions[selectedFraction]
                      : "0";
                  widget.onValueSelected({
                    'whole': wholeNum,
                    'fraction': frac,
                    'unit': widget.unit[selectedUnit],
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
