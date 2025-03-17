import 'package:flutter/material.dart';

class ProfileItems extends StatelessWidget {
  final int id;
  final String name;
  final int age;
  final int selectedId;
  final Function(int) onSelect;
  final VoidCallback onTap;

  const ProfileItems({
    super.key,
    required this.id,
    required this.name,
    required this.age,
    required this.selectedId,
    required this.onSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$age years old',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            IgnorePointer(
              ignoring: false,
              child: Radio<int>(
                value: id,
                activeColor: Colors.green,
                groupValue: selectedId,
                onChanged: (value) {
                  onSelect(id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
