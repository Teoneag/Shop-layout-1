import 'package:flutter/material.dart';

Widget loadingCenter() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

const successS = 'Success!';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
