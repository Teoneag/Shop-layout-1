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
  late String _email;
  bool _isLoading = false;
  String? _emailError;

  Future _verifyEmail() async {
    setState(() {
      _isLoading = true;
    });
    await _verifiEmailLogic();
    setState(() {
      _isLoading = false;
    });
  }

  Future _verifiEmailLogic() async {
    try {
      String res = await AuthM.verifyEmail(_email);
      if (res != successS) {
        _emailError = res;
        setState(() {});
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _email = widget.initialEmail ?? '';
    _verifyEmail();
  }

  @override
  Widget build(BuildContext context) {
    return centerFormScaffol(
      context,
      GlobalKey<FormState>(),
      [
        Text('Verify your email',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        _emailError == null
            ? Text(
                'We sent an email to $_email. Click the link inside to get started.',
                textAlign: TextAlign.center,
              )
            : Text(_emailError!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
        const SizedBox(height: 20),
        _isLoading
            ? loadingCenter()
            : ElevatedButton(
                onPressed: () => _verifyEmail(),
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
            arguments: _email,
          ),
          child: const Text('Back to log in'),
        ),
      ],
    );
  }
}
