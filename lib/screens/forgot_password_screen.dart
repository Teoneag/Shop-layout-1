import 'package:flutter/material.dart';
import '/utils/routes.dart';
import '/widgets/auth_widgets.dart';
import '/utils/utils.dart';
import '/firebase/auth_methods.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEmailSend = false;
  String? emailError;

  Future _forgotPassword() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthM.forgotPassword(_emailC.text);
    showSnackBar(res, context);
    if (res == successS) {
      setState(() {
        _isEmailSend = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailC.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return centerFormScaffol(
      context,
      _formKey,
      [
        Text('Reset passowrd', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text(
          'Enter your email address and we will send you instructions to reset your password.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        emailField(_emailC, emailError),
        const SizedBox(height: 20),
        _isLoading
            ? loadingCenter()
            : ElevatedButton(
                onPressed: () => _forgotPassword(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isEmailSend
                        ? const Text('Resend email')
                        : const Text('Send email'),
                  ],
                ),
              ),
        const SizedBox(height: 10),
        _isEmailSend
            ? const Text(
                'Email succesfully send.\nPlease check your email!',
                style: TextStyle(color: Colors.green),
              )
            : Container(),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.login,
            (route) => false,
            arguments: _emailC.text,
          ),
          child: const Text('Back to log in'),
        ),
      ],
    );
  }
}
