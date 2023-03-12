import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/post/post.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref("post");
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Post"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: postController,
            maxLines: 4,
            decoration: const InputDecoration(
                hintText: "What is in your mind?",
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 30,
          ),
          Button(
              text: "Add",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();

                databaseRef
                    // .child(_auth.currentUser!.uid)
                    .child(id)
                    .set({
                  "post": postController.text.toString(),
                  "id": id
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Fluttertoast.showToast(
                      msg: "Post added successfully",
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Post()));
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Fluttertoast.showToast(
                      msg: error.toString(),
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white);
                });
              })
        ]),
      ),
    );
  }
}
