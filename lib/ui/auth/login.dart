import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfirebase/ui/auth/forgot_password.dart';
import 'package:flutterfirebase/ui/auth/login_phone.dart';
import 'package:flutterfirebase/ui/auth/signup.dart';
import 'package:flutterfirebase/ui/firestore/firestore_post.dart';
// ignore: unused_import
import 'package:flutterfirebase/ui/post/post.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  // Firebase
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Form for email and password
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          helperText: "enter email e.g. abc@gmail.co",
                          prefixIcon: Icon(Icons.alternate_email_outlined)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter you mail id";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Password
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter you password";
                        } else if (value.length < 6) {
                          return "Password length must at atleast 6";
                        } else {
                          return null;
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Login button
              Button(
                text: "Login",
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _loginFunction();
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: const Text("Forgot Password")),
              ),
              // Signup button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUp()));
                      },
                      child: const Text("Sign up"))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Login through phone no.
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogInPhone()));
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black)),
                  child: const Center(child: Text("Login using phone no.")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loginFunction() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Login Successfully", backgroundColor: Colors.deepPurple);
      Navigator.push(
          // context, MaterialPageRoute(builder: (context) => const Post()));
          context,
          MaterialPageRoute(builder: (context) => const FirestorePost()));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(), backgroundColor: Colors.deepPurple);
    });
  }
}
