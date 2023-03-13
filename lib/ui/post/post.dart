import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/ui/auth/login.dart';
import 'package:flutterfirebase/ui/post/add_post.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref("post");

  final searchController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Screen"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _loggedOutUser(context);
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),

      // Displayign all posts
      body: Column(children: [
        // Expanded(
        //     child: StreamBuilder(
        //   stream: databaseRef.onValue,
        //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        //     if (!snapshot.hasData) {
        //       return const CircularProgressIndicator();
        //     } else {
        //       Map<dynamic, dynamic> map =
        //           snapshot.data!.snapshot.value as dynamic;

        //       List<dynamic> list = [];
        //       list.clear();
        //       list = map.values.toList();
        //       return ListView.builder(
        //           itemCount: snapshot.data!.snapshot.children.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               title: Text(list[index]['post']),
        //               subtitle: Text(list[index]['id']),
        //             );
        //           });
        //     }
        //   },
        // )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
                hintText: "Search", border: OutlineInputBorder()),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: FirebaseAnimatedList(
              query: databaseRef,
              itemBuilder: (context, snapshot, animation, index) {
                final post = snapshot.child("post").value.toString();
                final id = snapshot.child("id").value.toString();

                if (searchController.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child("post").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(post, id);
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text("Edit"),
                            )),
                        PopupMenuItem(
                            onTap: () {
                              databaseRef.child(id).remove().then((value) {
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
                            value: 2,
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text("Delete"),
                            ))
                      ],
                    ),
                  );
                } else if (post
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase().toString())) {
                  return ListTile(
                    title: Text(snapshot.child("post").value.toString()),
                    subtitle: Text(snapshot.child("id").value.toString()),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ]),

      //Adding post button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
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
                    databaseRef.child(id).update(
                        {"post": editController.text.toString()}).then((value) {
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

  void _loggedOutUser(BuildContext context) {
    _auth.signOut().then((value) {
      Fluttertoast.showToast(
        msg: "Logged out successfully",
        textColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LogIn()));
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
        msg: error.toString(),
        textColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      );
    });
  }
}
