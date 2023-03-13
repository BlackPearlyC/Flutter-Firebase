import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "Emial",
                  helperText: "enter email e.g. abc@gmail.co",
                  prefixIcon: Icon(Icons.alternate_email_outlined)),
            ),
            const SizedBox(
              height: 20,
            ),
            // Button
            Button(
                text: "Submit",
                onTap: () {
                  _auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    Fluttertoast.showToast(
                        msg:
                            "Email is send to your mail, please check you mail or spam folder",
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white);
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(
                        msg: error.toString(),
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
