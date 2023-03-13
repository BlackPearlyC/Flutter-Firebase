import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/login.dart';
import 'package:flutterfirebase/ui/firestore/firestore_add.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestorePost extends StatefulWidget {
  const FirestorePost({super.key});

  @override
  State<FirestorePost> createState() => _FirestorePostState();
}

class _FirestorePostState extends State<FirestorePost> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreRef =
      FirebaseFirestore.instance.collection('post').snapshots();
  final firestoreCollection = FirebaseFirestore.instance.collection('post');
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Firestore Post"),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LogIn()));
                Fluttertoast.showToast(
                    msg: "Logout Successfully",
                    backgroundColor: Colors.deepPurple,
                    textColor: Colors.white);
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(
                    msg: error.toString(),
                    backgroundColor: Colors.deepPurple,
                    textColor: Colors.white);
              });
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      // Firebase Post print
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestoreRef,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  Fluttertoast.showToast(
                      msg: "Some error occoured!, please reopen app",
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white);
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post =
                            snapshot.data!.docs[index]['post'].toString();
                        final id = snapshot.data!.docs[index]['id'].toString();
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['post'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(post, id);
                                  },
                                  child: const ListTile(
                                    title: Text("Edit"),
                                    leading: Icon(Icons.edit),
                                  )),
                              PopupMenuItem(
                                  value: 2,
                                  onTap: () {
                                    firestoreCollection
                                        .doc(snapshot.data!.docs[index]['id']
                                            .toString())
                                        .delete()
                                        .then((value) {
                                      Fluttertoast.showToast(
                                          msg: "Deleted Successfully",
                                          backgroundColor: Colors.deepPurple,
                                          textColor: Colors.white);
                                    }).onError((error, stackTrace) {
                                      Fluttertoast.showToast(
                                          msg: error.toString(),
                                          backgroundColor: Colors.deepPurple,
                                          textColor: Colors.white);
                                    });
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                  )),
                            ],
                          ),
                        );
                      }),
                );
              }),
        ],
      ),
      // floating button for adding post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const FirestoreAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String post, String id) async {
    editController.text = post;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          debugPrint(post);
          return AlertDialog(
            title: const Text("Update"),
            // ignore: avoid_unnecessary_containers
            content: Container(
              child: TextField(
                controller: editController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    firestoreCollection.doc(id).update(
                        {'post': editController.text.toString()}).then((value) {
                      Fluttertoast.showToast(
                          msg: "Updated successfully",
                          backgroundColor: Colors.deepPurple,
                          textColor: Colors.white);
                    }).onError((error, stackTrace) {
                      Fluttertoast.showToast(
                          msg: error.toString(),
                          backgroundColor: Colors.deepPurple,
                          textColor: Colors.white);
                    });
                  },
                  child: const Text("Update")),
            ],
          );
        });
  }
}
