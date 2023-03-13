import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/widgets/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  // ignore: unused_field
  File? _image;
  final picker = ImagePicker();

  bool loading = false;

// Reference of storage
  final storage = FirebaseStorage.instance.ref();

  final firestore = FirebaseFirestore.instance.collection('user');

  // final
// Process to pick the image
  Future getGalaryImage() async {
    final pickFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        Fluttertoast.showToast(
            msg: "No image is picked",
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Upload Image"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    getGalaryImage();
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: _image != null
                        ? Image.file(
                            _image!.absolute,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Button(
                  text: "Upload",
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });

                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    if (_image != null) {
                      final refImg = storage.child('images').child(id);
                      await refImg.putFile(_image!);
                      final imgURL = await refImg.getDownloadURL();

                      // Upload to firestore
                      firestore
                          .doc(id)
                          .set({'id': id, 'img': imgURL}).then((value) {
                        setState(() {
                          loading = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Uploded Successfully",
                            backgroundColor: Colors.deepPurple,
                            textColor: Colors.white);
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Fluttertoast.showToast(
                            msg: error.toString(),
                            backgroundColor: Colors.deepPurple,
                            textColor: Colors.white);
                      });
                    } else {
                      setState(() {
                        loading = false;
                      });
                      Fluttertoast.showToast(
                          msg: "No image is picked",
                          backgroundColor: Colors.deepPurple,
                          textColor: Colors.white);
                    }
                  })
            ]),
      ),
    );
  }
}
