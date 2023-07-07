import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shop_layout_1/utils/utils.dart';
import '/firebase/auth_methods.dart';
import '/utils/consts.dart';

Widget continueWithGoogleButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => AuthM.signInWithGoogle(context),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            googlelogoPath,
            height: 24.0,
          ),
          const SizedBox(width: 10),
          const Text('Continue with Google'),
        ],
      ),
    ),
  );
}

Widget orSeparator() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(child: Divider()),
      SizedBox(width: 15),
      Text('OR'),
      SizedBox(width: 15),
      Expanded(child: Divider()),
    ],
  );
}

Widget emailField(TextEditingController emailC) {
  return TextFormField(
    controller: emailC,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      hintText: 'Enter your email',
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your email';
      }
      if (EmailValidator.validate(value) == false) {
        return 'Please enter a valid email';
      }
      return null;
    },
  );
}

Widget passField(TextEditingController passC, BoolWrapper obscureText,
    StateSetter setState) {
  return TextFormField(
    controller: passC,
    keyboardType: TextInputType.visiblePassword,
    obscureText: obscureText.value,
    decoration: InputDecoration(
      hintText: 'Enter your password',
      suffixIcon: Tooltip(
        message: obscureText.value ? 'Show password' : 'Hide password',
        child: GestureDetector(
          onTap: () => setState(() => obscureText.value = !obscureText.value),
          child: Icon(
            obscureText.value ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'The password should be at least 6 characters long';
      }
      return null;
    },
  );
}
