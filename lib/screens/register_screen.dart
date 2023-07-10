import 'package:flutter/material.dart';
import '/widgets/auth_widgets.dart';
import '/utils/utils.dart';
import '/utils/routes.dart';
import '/firebase/auth_methods.dart';

class RegisterScreen extends StatefulWidget {
  final String? initialEmail;

  const RegisterScreen({super.key, this.initialEmail});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final BoolWrapper _obscureText = BoolWrapper(true);
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

  Future _register() async {
    setState(() {
      _isLoading = true;
    });
    await _registerLogic();
    setState(() {
      _isLoading = false;
    });
  }

  Future _registerLogic() async {
    try {
      emailError = '';
      passError = '';
      if (_formKey.currentState!.validate() == false) return;
      String res = await AuthM.registerUser(_emailC.text, _passC.text);
      if (res != successS) {
        if (res == 'unknown') {
          emailError = 'Unknown error, try to log in or continue with Google';
        }
        // else {
        //   print('res: $res');
        //   showSnakeBar(context, 'Something went wrong, please try again');
        // }
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.verifyEmail,
        (route) => false,
        arguments: _emailC.text,
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
        Text('Welcome, please register!',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        emailField(_emailC, emailError),
        const SizedBox(height: 10),
        passField(_passC, _obscureText, setState, passError),
        const SizedBox(height: 20),
        customButton1('Register', _register, _isLoading),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.login,
                    arguments: _emailC.text);
              },
              child: const Text('Log in'),
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
