import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/login.dart';
// ignore: unused_import
import 'package:flutterfirebase/ui/firestore/firestore_post.dart';
import 'package:flutterfirebase/ui/image/upload_image.dart';
// ignore: unused_import
import 'package:flutterfirebase/ui/post/post.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final user = _auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            // context, MaterialPageRoute(builder: (context) => const Post())
            context,
            // MaterialPageRoute(builder: (context) => const FirestorePost()));
            MaterialPageRoute(builder: (context) => const UploadImage()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LogIn()));
      });
    }
  }
}
