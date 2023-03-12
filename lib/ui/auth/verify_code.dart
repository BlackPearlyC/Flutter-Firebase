import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/post/post.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;
  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final verifyCodeController = TextEditingController();
  bool loading = false;

  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    verifyCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: verifyCodeController,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(hintText: "123 456"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter you verification code";
                  } else if (value.length < 6 || value.length > 6) {
                    return "6 digit code only";
                  } else {
                    return null;
                  }
                },
              )),
          const SizedBox(
            height: 50,
          ),
          Button(
              text: "Verify",
              loading: loading,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });

                  // ignore: unused_local_variable
                  final credential = PhoneAuthProvider.credential(
                      smsCode: verifyCodeController.text.toString(),
                      verificationId: widget.verificationId);

                  try {
                    await _auth.signInWithCredential(credential);
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Verified Successfully",
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white);
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Post()));
                  } catch (error) {
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(
                        msg: error.toString(),
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white);
                  }
                }
              })
        ]),
      ),
    );
  }
}
