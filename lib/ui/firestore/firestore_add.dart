import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/firestore/firestore_post.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreAdd extends StatefulWidget {
  const FirestoreAdd({super.key});

  @override
  State<FirestoreAdd> createState() => _FirestoreAddState();
}

class _FirestoreAddState extends State<FirestoreAdd> {
  final postController = TextEditingController();
  bool loading = false;
  final firestoreDatabase = FirebaseFirestore.instance.collection("post");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Add Post"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "What is in your mind?"),
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
                text: "Post",
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String docId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  firestoreDatabase.doc(docId).set({
                    'id': docId,
                    'post': postController.text.toString()
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(
                      msg: "Firestore post successfully",
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirestorePost()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Fluttertoast.showToast(
                      msg: error.toString(),
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white,
                    );
                  });
                })
          ],
        ),
      ),
    );
  }
}
