import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/login.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LogIn()));
    });
  }
}
