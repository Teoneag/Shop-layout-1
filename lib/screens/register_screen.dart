import 'package:flutter/material.dart';
import 'package:shop_layout_1/widgets/auth_widgets.dart';
import '/utils/consts.dart';
import '/utils/utils.dart';
import '/utils/routes.dart';
import '/firebase/auth_methods.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future registerUser() async {
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
          context, Routes.login, (route) => false);
    }
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
                Text('Welcome', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                emailField(_emailC),
                const SizedBox(height: 10),
                passField(_passC, _obscureText, setState),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: registerUser,
                  child: _isLoading
                      ? loadingCenterPadding()
                      : const Text('Register'),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: const Text('Log in'),
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
