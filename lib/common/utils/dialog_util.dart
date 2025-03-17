import 'package:blood_pressure/presentation/widgets/custom_popup_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class DialogUtil {
  static bool _isDialogOpen = false;

  static void hideLoading(BuildContext context) {
    if (!_isDialogOpen) return;

    _isDialogOpen = false;
    Navigator.of(context).pop();
  }

  static void showLoading(BuildContext context) {
    _isDialogOpen = true;

    Navigator.of(context).push(
      CustomPopupRoute<dynamic>(
        child: PopScope(
          canPop: false,
          child: Center(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CupertinoActivityIndicator(),
            ),
          ),
        ),
        barrierDismissible: false,
      ),
    );
  }
}
