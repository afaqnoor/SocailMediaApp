// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gridview/Model/firestore_model.dart';
import 'package:image_picker/image_picker.dart';

class SportsPost extends StatefulWidget {
  const SportsPost({Key? key}) : super(key: key);

  @override
  State<SportsPost> createState() => _SportsPostState();
}

class _SportsPostState extends State<SportsPost> {
  var _image;
  var video;
  String imageUrl = '';
  String videoUrl = '';
  bool isComplete = false;
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _image = await file.readAsBytes();
      setState(() {});
    }
  }

  Future<void> pickVideo() async {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      video = await file.readAsBytes();
    }
  }

  final description = TextEditingController();
  final name = TextEditingController();
  @override
  void dispose() {
    description.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isComplete
        ? const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(left: 50.0),
                child: Text("Sports Screen"),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: description,
                      maxLines: null,
                      minLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Description...",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: name,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Name Please...",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        pickVideo();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.video_camera_back_outlined),
                          SizedBox(
                            height: 5,
                            width: 10,
                          ),
                          Text("Add a video")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.photo),
                          SizedBox(
                            height: 5,
                            width: 10,
                          ),
                          Text("Add a photo")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //fixedSize: Size(context.screenWidth * 0.7, 50),
                            // backgroundColor: Vx.amber300,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          if (description.text.isNotEmpty) {
                            setState(() {
                              isComplete = true;
                            });
                            try {
                              if (_image != null) {
                                imageUrl = await FireStoreServices()
                                    .uploadImageToStorage('Post', _image);
                              }
                              if (video != null) {
                                videoUrl = await FireStoreServices()
                                    .uploadVideoToStorage('Post', video);
                              }
                              await FireStoreServices.postSports(
                                  description: description.text,
                                  name: name.text,
                                  imageUrl: imageUrl,
                                  videoUrl: videoUrl);
                              setState(() {
                                isComplete = false;
                              });
                              Fluttertoast.showToast(msg: 'Post Upload');
                              Navigator.pop(context);
                            } catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                              setState(() {
                                isComplete = false;
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Discription can be Empty');
                          }
                        },
                        child: const Text(
                          'Post',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
