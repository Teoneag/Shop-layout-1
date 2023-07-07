import 'package:flutter/material.dart';
import 'package:shop_layout_1/utils/utils.dart';
import '/firebase/auth_methods.dart';
import '/utils/routes.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log out'),
      content: const Text('Are you sure u want to log out?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () async {
              await AuthM.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.login, (route) => false);
              showSnackBar(successS, context);
            },
            child: const Text('Log out')),
      ],
    );
  }
}
