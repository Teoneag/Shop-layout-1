import 'package:flutter/material.dart';

Widget loadingCenter() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget loadingCPTextSize() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      ),
    ),
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

class BoolW {
  bool value;
  BoolW(this.value);
}

class StringW {
  String? v;
  StringW(this.v);
}
