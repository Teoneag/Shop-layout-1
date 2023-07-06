import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '/utils/consts.dart';
import '/utils/utils.dart';
import '/utils/routes.dart';
import '/firebase/auth_methods.dart';

// TODO: add forgot password, veify email
// TODO: there is not user, wrong password, other errors
// TODO: modify the register screen
// add language support
// terms of use & privacy policy

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future loginUser() async {
    if (_formKey.currentState!.validate() == false) return;
    setState(() {
      _isLoading = true;
    });
    String res = await AuthM.loginUser(_emailC.text, _passC.text);
    if (res != successS) {}
    showSnackBar(res, context);
    if (res == successS) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (route) => false);
    }
    setState(() {
      _isLoading = false;
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
                TextFormField(
                  controller: _emailC,
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
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passC,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: Tooltip(
                      message: _obscureText ? 'Show password' : 'Hide password',
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _obscureText = !_obscureText),
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginUser,
                  child: _isLoading ? loadingCenter() : const Text('Log in'),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 15),
                    Text('OR'),
                    SizedBox(width: 15),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 23),
                ElevatedButton(
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
                ),
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
