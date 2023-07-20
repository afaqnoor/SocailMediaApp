import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Comments');
  final firestore =
      FirebaseFirestore.instance.collection('Comments').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // leading: const Icon(Icons.menu),
        title: const Center(
          child: Text(
            'Comments',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: firestore,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Some want Wrong');
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.person_outline_outlined,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  title: Text(snapshot
                                      .data!.docs[index]['commit']
                                      .toString()),
                                );
                              }),
                        );
                      }
                      return const Text('');
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: 'Comments...',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                String id = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                fireStore
                                    .doc(id)
                                    .set({
                                      'commit':
                                          commentController.text.toString(),
                                      'Uid': id,
                                    })
                                    .then((value) {})
                                    .onError((error, stackTrace) {
                                      Fluttertoast.showToast(
                                          msg: 'Something was wrong');
                                    });
                                commentController.clear();
                              },
                              icon: const Icon(Icons.send))),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
