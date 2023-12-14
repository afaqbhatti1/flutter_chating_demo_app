// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final ChatUser chatUser;
  final User firestoreuser;

  const CompleteProfile({
    Key? key,
    required this.chatUser,
    required this.firestoreuser,
  }) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    imageSelect(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from gallery"),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    imageSelect(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Select from camera"),
                ),
              ],
            ),
          );
        });
  }

  File? imagefile;
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  TextEditingController teacherNamecontroller = TextEditingController();
  TextEditingController hobbiescontroller = TextEditingController();
  TextEditingController favBookscontroller = TextEditingController();

  void checkValues() {
    String fullname = fullnamecontroller.text.trim();
    String about = aboutcontroller.text.trim();
    String teacherName = aboutcontroller.text.trim();
    String hobbies = hobbiescontroller.text.trim();
    String favBooks = favBookscontroller.text.trim();

    if (imagefile != null || fullname != "" || about != "") {
      uploadData(fullname, about, teacherName, hobbies, favBooks);
    } else {
      print("Please Fill all Values");
    }
  }

  void uploadData(
    String fullname,
    String about,
    String teacherName,
    String hobbies,
    String favBooks,
  ) async {
    UploadTask uploadTask =
        FirebaseStorage.instance.ref("profilepics").child(widget.chatUser.uid.toString()).putFile(imagefile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imgUrl = await snapshot.ref.getDownloadURL();

    widget.chatUser.profilepic = imgUrl;
    widget.chatUser.username = fullname;
    widget.chatUser.about = about;
    widget.chatUser.techerName = teacherName;
    widget.chatUser.hobbies = hobbies;
    widget.chatUser.favBooks = favBooks;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.chatUser.uid.toString())
        .set(widget.chatUser.toJson())
        .then(
      (value) {
        Fluttertoast.showToast(
          msg: "Loggin In",
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return HomePage(
            chatUser: widget.chatUser,
            firestoreuser: widget.firestoreuser,
          );
        })));
      },
    );
  }

  void imageSelect(ImageSource source) async {
    XFile? pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      cropImage(pickedimage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    ));

    if (cropedImage != null) {
      setState(() {
        imagefile = File(cropedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Your Profile Info"),
        backgroundColor: const Color(0xff2865DC),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 35,
            right: 35,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showPhotoOptions();
                  },
                  child: CircleAvatar(
                    backgroundImage: (imagefile != null) ? FileImage(imagefile!) : null,
                    radius: 60,
                    child: (imagefile == null) ? const Icon(Icons.person) : null,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: fullnamecontroller,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: aboutcontroller,
                  decoration: const InputDecoration(
                    labelText: "About Yourself",
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: teacherNamecontroller,
                  decoration: const InputDecoration(
                    labelText: "Teacher Name",
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: hobbiescontroller,
                  decoration: const InputDecoration(
                    labelText: "Hobbies",
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: favBookscontroller,
                  decoration: const InputDecoration(
                    labelText: "Favourite Books ",
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                LoginButton(
                  height: 50,
                  width: 200,
                  buttoncolor: const Color(0xff2865DC),
                  radius: 30,
                  onPressed: () {
                    checkValues();
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
