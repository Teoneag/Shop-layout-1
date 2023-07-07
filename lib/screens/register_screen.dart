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
    if (_formKey.currentState!.validate() == false) return;
    setState(() {
      _isLoading = true;
    });
    String res = await AuthM.registerUser(_emailC.text, _passC.text);
    setState(() {
      _isLoading = false;
    });
    showSnackBar(res, context);
    if (res == successS) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.verifyEmail,
        (route) => false,
        arguments: _emailC.text,
      );
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
        emailField(_emailC),
        const SizedBox(height: 10),
        passField(_passC, _obscureText, setState),
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
