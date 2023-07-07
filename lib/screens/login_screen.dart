import 'package:flutter/material.dart';
import 'package:shop_layout_1/widgets/auth_widgets.dart';
import '/utils/consts.dart';
import '/utils/utils.dart';
import '/utils/routes.dart';
import '/firebase/auth_methods.dart';

// TODO: add forgot password, veify email
// TODO: there is not user, wrong password, no internet, bad email for forgot password, other errors
// TODO: modify the register screen
// add language support
// terms of use & privacy policy
// TODO: widget vs stateless widget

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final BoolWrapper _obscureText = BoolWrapper(true);
  bool _isLoading = false;
  bool _isForgotLoading = false;
  bool _isEmailSend = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future _loginUser() async {
    if (_formKey.currentState!.validate() == false) return;
    setState(() {
      _isLoading = true;
    });
    String res = await AuthM.loginUser(_emailC.text, _passC.text);
    if (res != successS) {} // TODO: handel the errors
    showSnackBar(res, context);
    if (res == successS) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _forgotPassword() async {
    setState(() {
      _isForgotLoading = true;
    });

    String res = await AuthM.forgotPassword(_emailC.text);
    showSnackBar(res, context);
    if (res == successS) {
      setState(() {
        _isEmailSend = true;
      });
    }
    setState(() {
      _isForgotLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300 + MediaQuery.of(context).size.width * 0.1,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(appName, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                Text('Welcome back',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                emailField(_emailC),
                const SizedBox(height: 10),
                passField(_passC, _obscureText, setState),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loginUser,
                  child: _isLoading ? loadingCenter() : const Text('Log in'),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _isForgotLoading
                      ? loadingCenter()
                      : Row(
                          children: [
                            TextButton(
                              onPressed: () => _forgotPassword(),
                              child: _isEmailSend
                                  ? const Text('Resend email')
                                  : const Text('Forgot password?'),
                            ),
                            _isEmailSend
                                ? const Text(
                                    'Email send. Check inbox!',
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Container(),
                          ],
                        ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                orSeparator(),
                const SizedBox(height: 23),
                continueWithGoogleButton(context),
                const Spacer(),
                const Text('Terms of use | Privacy policy'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
