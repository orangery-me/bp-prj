import 'package:blood_pressure/common/theme/text_custom_style.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class DataPickerRow extends StatefulWidget {
  final String title;
  final List<String> items;
  final void Function(String) onSelected;
  const DataPickerRow({super.key, required this.title, required this.items, required this.onSelected});

  @override
  State<DataPickerRow> createState() => _DataPickerRowState();
}

class _DataPickerRowState extends State<DataPickerRow> {
  String selectedItem = '';

  @override
  void initState() {
    super.initState();
    selectedItem = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    final String titleDescription = 'Select your ${widget.title}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title, style: TextCustomStyle.mediumTitle),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(selectedItem, style: TextCustomStyle.mediumText),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
          onTap: () {
            DropDownState(DropDown(
              data: widget.items.map((e) => SelectedListItem(name: e)).toList(),
              bottomSheetTitle: Text(titleDescription),
              dropDownBackgroundColor: Colors.white,
              isSearchVisible: false,
              onSelected: (List<dynamic> selectedList) {
                setState(() {
                  selectedItem = selectedList[0].name;
                });
                widget.onSelected(selectedItem);
              },
            )).showModal(context);
          },
        )
      ],
    );
  }
}
