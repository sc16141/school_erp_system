import 'package:flutter/material.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';

class LogoutDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeResponsiveness.getCardBorderRadius(context),
            ),
          ),
          title: Text('Logout', style: AppThemeResponsiveness.getSubtitleTextStyle(context)),
          content: Text(
            'Are you sure you want to logout?',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: AppThemeResponsiveness.getButtonTextStyle(context)
                    .copyWith(color: AppThemeColor.primaryBlue),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppThemeResponsiveness.getInputBorderRadius(context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                  vertical: AppThemeResponsiveness.getSmallSpacing(context),
                ),
              ),
              child: Text(
                'Logout',
                style: AppThemeResponsiveness.getButtonTextStyle(context)
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
