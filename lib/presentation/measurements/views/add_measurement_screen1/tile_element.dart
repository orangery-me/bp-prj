import 'package:flutter/material.dart';

class TileElement extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final String? hintText;
  final void Function()? validate;

  const TileElement(
      {super.key,
      required this.title,
      required this.subtitle,
      this.hintText,
      required this.controller,
      this.validate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Container(
        width: 100,
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          onChanged: (value) => {
            if (validate != null) {validate!()}
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
