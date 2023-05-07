import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Text("Here's your email address to verify: ${user?.email ?? ""}"),
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your email here if above email isn\'t yours',
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: 'Enter your password here',
          ),
        ),
        TextButton(
            onPressed: () async {
              if (user?.email == _email.text) {
                await user?.sendEmailVerification();
              } else {
                try {
                  final email = _email.text;
                  final pwd = _password.text;
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: pwd);
                  print(userCredential);
                  await user?.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print("User not found!");
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password!');
                  }  else {
                    print('something went wrong with error: ${e.code}');
                  }
                }
              }
            },
            child: const Text('Send email verification'))
      ],
    );
  }
}
