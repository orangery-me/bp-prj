import 'package:flutter/material.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final String? secondButtonText;
  final void Function()? onButtonPressed;
  final void Function()? onSecondButtonPressed;

  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = 'OK',
    this.secondButtonText = 'Cancel',
    this.onButtonPressed,
    this.onSecondButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text(title)),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(content),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6650DD)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onButtonPressed ??
                    () {
                      Navigator.of(context).pop();
                    },
                child: Text(buttonText,
                    style: const TextStyle(color: Color(0xFF6650DD))),
              ),
            ),
            const SizedBox(width: 10),
            if (secondButtonText != null)
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6650DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onSecondButtonPressed ??
                      () {
                        Navigator.of(context).pop();
                      },
                  child: Text(secondButtonText!),
                ),
              ),
          ],
        )
      ],
    );
  }
}
