import 'package:flutter/material.dart';
import '/utils/routes.dart';
import '/widgets/auth_widgets.dart';
import '/utils/utils.dart';
import '/firebase/auth_methods.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String? initialEmail;

  const VerifyEmailScreen({super.key, this.initialEmail});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future _verifiEmail() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthM.verifyEmail(_emailC.text);
    showSnackBar(res, context);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailC.text = widget.initialEmail ?? '';
    _verifiEmail();
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
        Text('Verify your email',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text(
          'We sent an email. Click the link inside to get started.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        emailField(_emailC),
        const SizedBox(height: 20),
        _isLoading
            ? loadingCenter()
            : ElevatedButton(
                onPressed: () => _verifiEmail(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Resend email'),
                  ],
                ),
              ),
        const SizedBox(height: 10),
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
