// ignore_for_file: prefer_typing_uninitialized_variables, unused_field
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({
    super.key,
    id,
  });

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final auth = FirebaseAuth.instance;
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    // print(widget.image);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Center(
          child: Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 225, 225),
              // border:
              //     Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 18.0, left: 10, right: 10),
                  child: Text(
                    'What Is Social Media? Social media facilitates the sharing of ideas and information through virtual networks. From Facebook and Instagram to Twitter and YouTube, social media covers a broad universe of apps and platforms that allow users to share content, interact online, and build communities',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
