import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/verify_code.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogInPhone extends StatefulWidget {
  const LogInPhone({super.key});

  @override
  State<LogInPhone> createState() => _LogInPhoneState();
}

class _LogInPhoneState extends State<LogInPhone> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final phoneNoController = TextEditingController();

  bool loading = false;

  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    phoneNoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Using Phone No."),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNoController,
              decoration: const InputDecoration(hintText: "+1 234 5342 234"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your phone no.";
                } else {
                  return null;
                }
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Button(
              text: "Login",
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _otpSending(context);
                }
              })
        ]),
      ),
    );
  }

  void _otpSending(BuildContext context) {
    setState(() {
      loading = true;
    });
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNoController.text.toString(),
        verificationCompleted: (_) {
          setState(() {
            loading = false;
          });
        },
        verificationFailed: (error) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: error.toString(),
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white);
        },
        codeSent: (String verificationId, int? token) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: "Verification code send successfully",
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyCode(verificationId: verificationId)));
        },
        codeAutoRetrievalTimeout: (error) {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: error.toString(),
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white);
        });
  }
}
