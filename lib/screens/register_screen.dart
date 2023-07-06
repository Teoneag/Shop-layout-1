import 'package:flutter/material.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future registerUser() async {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appName, style: Theme.of(context).textTheme.titleLarge),
              Center(
                child: SizedBox(
                  width: 300 + MediaQuery.of(context).size.width * 0.1,
                  child: Column(
                    children: [
                      // svg image
                      // SvgPicture.asset(
                      //   'assets/logo_CoinSky_1_2.svg',
                      //   height: 90,
                      // ),
                      Text('Welcome',
                          style: Theme.of(context).textTheme.titleLarge),

                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailC,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(hintText: 'Enter your email'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passC,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            hintText: 'Enter your password'),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        // TODO: add padding
                        onPressed: registerUser,
                        child: _isLoading
                            ? loadingCenter()
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
                    ],
                  ),
                ),
              ),
              const Text('Terms of use | Privacy policy'),
            ],
          ),
        ),
      ),
    );
  }
}
