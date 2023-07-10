import 'package:flutter/material.dart';
import '/widgets/auth_widgets.dart';
import '/utils/utils.dart';
import '/utils/routes.dart';
import '/firebase/auth_methods.dart';

// TODO: what to do with the snake dialogs, should i add open email?
// TODO: there is not user, wrong password, no internet, bad email for forgot password, other errors
// TODO: add language support
// TODO: terms of use & privacy policy

class LoginScreen extends StatefulWidget {
  final String? initialEmail;

  const LoginScreen({super.key, this.initialEmail});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final BoolWrapper _obscureText = BoolWrapper(true);
  bool _isLoading = false;
  String? emailError;
  String? passError;

  @override
  void initState() {
    super.initState();
    _emailC.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future _login() async {
    setState(() {
      _isLoading = true;
    });
    await _loginLogic();
    setState(() {
      _isLoading = false;
    });
  }

  Future _loginLogic() async {
    try {
      emailError = '';
      passError = '';
      if (_formKey.currentState!.validate() == false) return;
      String res = await AuthM.loginUser(_emailC.text, _passC.text);
      if (res != successS) {
        print('res: $res');
        if (res == verifyEmailS) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.verifyEmail,
            (_) => false,
            arguments: _emailC.text,
          );
        } else if (res == 'user-not-found' || res == 'unknown') {
          emailError =
              'User not found, please register or continue with Google';
        } else if (res == 'wrong-password') {
          passError = 'Wrong password';
        }
        setState(() {});
        _formKey.currentState!.validate();
        return;
      } // TODO: handel the errors
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (_) => false,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return centerFormScaffol(
      context,
      _formKey,
      [
        Text('Welcome back', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        emailField(_emailC, emailError),
        const SizedBox(height: 10),
        passField(_passC, _obscureText, setState, passError),
        const SizedBox(height: 20),
        customButton1('Log in', _login, _isLoading),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.forgotPassowrd, (_) => false,
                arguments: _emailC.text),
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.register, (_) => false,
                    arguments: _emailC.text);
              },
              child: const Text('Register'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        orSeparator(),
        const SizedBox(height: 23),
        continueWithGoogleButton(context),
      ],
    );
  }
}
