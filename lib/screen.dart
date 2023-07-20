// import 'package:flutter/material.dart';

// class Screen extends StatefulWidget {
//   const Screen({super.key});

//   @override
//   State<Screen> createState() => _ScreenState();
// }

// class _ScreenState extends State<Screen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(168, 4, 182, 214),
//           leading: const Icon(
//             Icons.menu,
//             color: Colors.black,
//           ),
//           title: const Text(
//             'Reddit',
//             style: TextStyle(color: Colors.black),
//           ),
//           actions: const [
//             Icon(
//               Icons.search,
//               color: Colors.black,
//             ),
//           ],
//           elevation: 0.2,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 15,
//               width: double.infinity,
//               color: const Color.fromARGB(168, 4, 182, 214),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: const [
//                   Icon(
//                     Icons.arrow_back,
//                     size: 20,
//                   ),
//                   Text(
//                     'Today I Learned',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   Icon(
//                     Icons.error_outline_outlined,
//                     size: 20,
//                   ),
//                   Icon(Icons.vertical_split)
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 28.0, top: 20, right: 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "TIL millennials aren't buying diamonds anymore-millennials would rather spend money on experience than daimonds",
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   const Icon(
//                     Icons.share_outlined,
//                     size: 20,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height / 4,
//                     width: MediaQuery.of(context).size.width / 1.1,
//                     color: Colors.amber,
//                     child: Image.network(
//                       'https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Screen'),
      ),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * .65,
              child: Image.asset('assets/images/6.jpg')),
          ElevatedButton(
              onPressed: () {
                Share.share('com.example.gridview');
              },
              child: const Text('Share'))
        ],
      ),
    );
  }
}
