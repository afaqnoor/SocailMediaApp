import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
            'Chat',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 128, 196, 214),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('Hi,Brain')),
            ),
            const SizedBox(
              height: 17,
            ),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 128, 196, 214),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('can you send prensentation')),
            ),
            const SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 218.0),
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 223, 227),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('Yoo,sure NIKI')),
              ),
            ),
            const SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110.0),
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 198, 223, 230),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('let me find the prensentation')),
              ),
            ),
            const SizedBox(
              height: 370,
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.attach_file),
                    Text('Type a messge...'),
                    SizedBox(
                      width: 130,
                    ),
                    Icon(Icons.send)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
