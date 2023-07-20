// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gridview/Services/notification_services.dart';
// import 'package:gridview/pages/CommentsSection/comments_page.dart';
// import 'package:gridview/pages/PostScreen/post_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:share_plus/share_plus.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   String? username;
//   String? email;
//   bool favorite1 = false;
//   bool favorite2 = false;
//   bool favorite3 = false;
//   bool favorite4 = false;
//   bool favorite5 = false;
//   bool favorite6 = false;
//   bool favorite7 = false;
//   bool favorite8 = false;
//   bool favorite9 = false;
//   bool favorite10 = false;
//   bool favorite11 = false;

//   _getDataFromDatabase() async {
//     await FirebaseFirestore.instance
//         .collection("UserData")
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get(const GetOptions(source: Source.cache))
//         .then((snapshot) async {
//       if (snapshot.exists &&
//           snapshot.get('username') != null &&
//           snapshot.get('email') != null) {
//         setState(() {
//           username = snapshot.data()!['username'];
//           email = snapshot.data()!['email'];
//         });
//       } else {
//         setState(() {
//           username = snapshot.data()!['username'];
//           email = snapshot.data()!['email'];
//         });
//       }
//     });
//   }

//   NotificationServices notificationServices = NotificationServices();
//   @override
//   void initState() {
//     _getDataFromDatabase();

//     super.initState();
//     notificationServices.requestNotificationPermission();
//     notificationServices.firebaseInit();
//     notificationServices.isTokenRefesh();
//     notificationServices.getDeviceToken().then((value) {
//       print('Device Token');
//       print(value);
//     });
//   }

//   final searchController = TextEditingController();
//   File? _image;
//   String? imageURL;
//   final picker = ImagePicker();
//   String? name;
//   Future getImageFromGallery() async {
//     // ignore: deprecated_member_use
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         name = (_image!.path);
//       }
//     });
//     Reference ref = FirebaseStorage.instance.ref().child(name.toString());

//     await ref.putFile(File(_image!.path));
//     ref.getDownloadURL().then((value) async {
//       setState(() {
//         imageURL = value;
//       });
//     });
//   }

//   final fireStore =
//       FirebaseFirestore.instance.collection('recommendations').snapshots();
//   // ignore: non_constant_identifier_names
//   Widget BottomSheet() {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 13,
//       width: double.infinity,
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () {
//               getImageFromGallery();
//             },
//             child: const ListTile(
//               leading: Icon(Icons.image),
//               title: Text('Gallery'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     TabController tabController = TabController(length: 4, vsync: this);
//     return SafeArea(
//       child: Scaffold(
//         drawer: Drawer(
//           width: 280,
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 30),
//                   child: Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       InkWell(
//                         onTap: () async {
//                           showModalBottomSheet(
//                               context: context,
//                               builder: (builder) => BottomSheet());
//                           //print('upload pic');
//                           // Navigator.pop(context);
//                           firebase_storage.Reference ref = firebase_storage
//                               .FirebaseStorage.instance
//                               .ref('/profile');

//                           //print('uplaod profile');
//                           firebase_storage.UploadTask uploadTask =
//                               ref.putFile(_image!.absolute);
//                           Navigator.pop(context);
//                           Future.value(uploadTask).then((value) {
//                             // ignore: unused_local_variable
//                             var newUrl = ref.getDownloadURL();

//                             // databaseRef
//                             //     .child('1')
//                             //     .set({'id': '1212', 'title': newUrl.toString()});

//                             Fluttertoast.showToast(msg: 'Uploaded');
//                           }).onError((error, stackTrace) {
//                             Fluttertoast.showToast(
//                                 msg: 'Image Was Not Uploaded');
//                           });
//                         },
//                         child: CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.amber,
//                           child: _image != null
//                               ? ClipOval(
//                                   child: Image.file(
//                                     _image!,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )
//                               : ClipOval(
//                                   child:
//                                       Image.asset('assets/images/empty.webp'),
//                                 ),
//                         ),
//                       ),
//                       // const SizedBox(
//                       //   width: 20,
//                       // ),
//                       StreamBuilder<QuerySnapshot>(
//                           stream: fireStore,
//                           builder: (BuildContext contex,
//                               AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return const CircularProgressIndicator();
//                             }
//                             if (snapshot.hasError) {
//                               return const Text('Some Error');
//                             }
//                             return Expanded(
//                                 child: SizedBox(
//                               height: 100,
//                               child: Padding(
//                                   padding: const EdgeInsets.only(right: 20.0),
//                                   child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 18.0, top: 20),
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             snapshot.data!.docs.length
//                                                 .toString(),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 20),
//                                           ),
//                                           const Text(
//                                             'Post',
//                                             style: TextStyle(fontSize: 15),
//                                           )
//                                         ],
//                                       ))),
//                             ));
//                           }),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 0.0, bottom: 10, right: 150),
//                   child: Text(
//                     username.toString(),
//                     style: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 15.0, bottom: 10, right: 100),
//                   child: Text(
//                     email.toString(),
//                     style: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const Divider(
//                   color: Color.fromARGB(255, 179, 167, 166),
//                   thickness: 1,
//                 ),

//                 ListTile(
//                   leading: const Icon(
//                     Icons.home,
//                     color: Colors.red,
//                   ),
//                   title: const Text(
//                     'Home',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),

//                 ListTile(
//                   leading: const Icon(Icons.notifications),
//                   title: const Text('Notifications'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 //here is a divider
//                 ListTile(
//                   leading: const Icon(Icons.check_box_outline_blank),
//                   title: const Text('My subreddits'),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (ctx) => const PostScreen()));
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 55.0),
//                   child: ListTile(
//                     title: const Text('Gaming'),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (ctx) => const PostScreen()));
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 55.0),
//                   child: ListTile(
//                     title: const Text('Funny'),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (ctx) => const PostScreen()));
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 55.0),
//                   child: ListTile(
//                     title: const Text('Series'),
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (ctx) => const PostScreen()));
//                     },
//                   ),
//                 ),
//                 const Divider(
//                   color: Color.fromARGB(255, 179, 167, 166),
//                   thickness: 1,
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.face),
//                   title: const Text('About'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.device_unknown_outlined),
//                   title: const Text('Help'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.settings),
//                   title: const Text('Apps & Tools'),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           // leading: const Icon(Icons.menu),
//           title: Row(
//             children: const [
//               Icon(
//                 Icons.face,
//                 color: Colors.red,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 'reddit',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: TextFormField(
//                 onChanged: (String _) {
//                   setState(() {});
//                 },
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   hintText: "Search .....",
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   //fillColor: Vx.gray200,
//                   filled: true,
//                 ),
//               ),
//             ),
//             searchController.text.isEmpty
//                 //searchController.text.isEmpty,
//                 ? Container(
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(
//                         27.0,
//                       ),
//                     ),
//                     child: TabBar(
//                         labelColor: Colors.blue,
//                         unselectedLabelColor: Colors.black,
//                         indicatorSize: TabBarIndicatorSize.label,
//                         indicatorColor: Colors.black,
//                         indicatorWeight: 3,
//                         controller: tabController,
//                         tabs: const [
//                           Tab(
//                             child: Text(
//                               'Politics',
//                               style: TextStyle(
//                                   fontFamily: 'Mirai Futura-Demo',
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 11),
//                             ),
//                           ),
//                           Tab(
//                             child: Text(
//                               'Technology',
//                               style: TextStyle(
//                                   fontFamily: 'Mirai Futura-Demo',
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 11),
//                             ),
//                           ),
//                           Tab(
//                             child: Text(
//                               'Science',
//                               style: TextStyle(
//                                   fontFamily: 'Mirai Futura-Demo',
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 11),
//                             ),
//                           ),
//                           Tab(
//                             child: Text(
//                               'Sports',
//                               style: TextStyle(
//                                   fontFamily: 'Mirai Futura-Demo',
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                   fontSize: 11),
//                             ),
//                           )
//                         ]),
//                   )
//                 : Expanded(
//                     child: StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('UserData')
//                             .where('username',
//                                 isGreaterThanOrEqualTo: searchController.text)
//                             .snapshots(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return const CircularProgressIndicator();
//                           } else if (snapshot.data!.docs.isEmpty) {
//                             return const Text(
//                               'No User Found',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.normal, fontSize: 20),
//                             );
//                           } else {
//                             var snap = snapshot.data!.docs;
//                             return ListView(
//                                 children: List.generate(
//                               snap.length,
//                               (index) {
//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(left: 28.0),
//                                       child: Text(
//                                         snapshot.data!.docs[index]['username']
//                                             .toString(),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 20),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               },
//                             ));
//                           }
//                         }),
//                   ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: TabBarView(
//                   physics: const BouncingScrollPhysics(),
//                   controller: tabController,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.0,
//                         right: 20,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             StreamBuilder<QuerySnapshot>(
//                                 stream: fireStore,
//                                 builder: (BuildContext contex,
//                                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return const CircularProgressIndicator();
//                                   }
//                                   if (snapshot.hasError) {
//                                     return const Text('Some Error');
//                                   }
//                                   return ListView.builder(
//                                       itemCount: snapshot.data!.docs.length,
//                                       itemBuilder: (context, index) {
//                                         return Expanded(
//                                           child: Container(
//                                               height: 400,
//                                               width: double.infinity,
//                                               decoration: BoxDecoration(
//                                                 color: const Color.fromARGB(
//                                                     255, 227, 225, 225),
//                                                 // border:
//                                                 //     Border.all(color: Colors.black, width: 2),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                               ),
//                                               child: Column(children: [
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     snapshot
//                                                         .data!
//                                                         .docs[index]
//                                                             ['recommendations']
//                                                         .toString(),
//                                                     style: const TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 200,
//                                                   width: double.infinity,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 8.0),
//                                                     child: Image(
//                                                         fit: BoxFit.cover,
//                                                         image: NetworkImage(
//                                                             snapshot
//                                                                 .data!
//                                                                 .docs[index][
//                                                                     'image_url']
//                                                                 .toString())),
//                                                   ),
//                                                 ),
//                                                 Row(children: [
//                                                   IconButton(
//                                                     icon: Icon(
//                                                       Icons.favorite,
//                                                       size: 25,
//                                                       color: favorite1
//                                                           ? Colors.red
//                                                           : const Color
//                                                                   .fromARGB(255,
//                                                               114, 113, 113),
//                                                     ),
//                                                     onPressed: () {
//                                                       setState(() {
//                                                         favorite1 = !favorite1;
//                                                       });
//                                                     },
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 12,
//                                                   ),
//                                                   IconButton(
//                                                       onPressed: () {
//                                                         Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                                 builder: (ctx) =>
//                                                                     const CommentPage()));
//                                                       },
//                                                       icon: const Icon(
//                                                           Icons.chat)),
//                                                   const SizedBox(
//                                                     width: 12,
//                                                   ),
//                                                   IconButton(
//                                                       onPressed: () {
//                                                         Share.share(
//                                                             'This is me');
//                                                       },
//                                                       icon: const Icon(
//                                                           Icons.share)),
//                                                   const SizedBox(
//                                                     width: 100,
//                                                   ),
//                                                   const Icon(
//                                                     Icons.save_rounded,
//                                                     color: Colors.black,
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 20,
//                                                   )
//                                                 ]),
//                                               ])),
//                                         );
//                                       });
//                                 }),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.0,
//                         right: 20,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/1.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite11
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite11 = !favorite11;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/2.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite10
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite10 = !favorite10;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/3.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite7
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite7 = !favorite7;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/4.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite5
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite5 = !favorite5;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/5.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite5
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite5 = !favorite5;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/6.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite4
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite4 = !favorite4;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/7.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite2
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite2 = !favorite2;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/8.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite3
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite3 = !favorite3;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/9.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite9
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite9 = !favorite9;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/10.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(
//                                             Icons.favorite,
//                                             size: 25,
//                                             color: favorite6
//                                                 ? Colors.red
//                                                 : const Color.fromARGB(
//                                                     255, 114, 113, 113),
//                                           ),
//                                           onPressed: () {
//                                             setState(() {
//                                               favorite6 = !favorite6;
//                                             });
//                                           },
//                                         ),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (ctx) =>
//                                                           const CommentPage()));
//                                             },
//                                             icon: const Icon(Icons.chat)),
//                                         const SizedBox(
//                                           width: 12,
//                                         ),
//                                         const Icon(
//                                           Icons.send,
//                                           color: Colors.black,
//                                         ),
//                                         const SizedBox(
//                                           width: 150,
//                                         ),
//                                         const Icon(
//                                           Icons.save_rounded,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.0,
//                         right: 20,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/1.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/2.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/3.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/4.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/5.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/6.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/7.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/8.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/9.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/10.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.0,
//                         right: 20,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/3.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/9.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/4.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/7.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/8.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/10.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/9.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/3.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/6.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 1.1,
//                                 decoration: BoxDecoration(
//                                   color:
//                                       const Color.fromARGB(255, 227, 225, 225),
//                                   // border:
//                                   //     Border.all(color: Colors.black, width: 2),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Japanes Convenience store will use VR controlled robots to stack shelves',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Image.asset(
//                                           'assets/images/1.jpg',
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.favorite,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (ctx) =>
//                                                             const CommentPage()));
//                                               },
//                                               icon: const Icon(Icons.chat)),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           const Icon(
//                                             Icons.send,
//                                             color: Colors.black,
//                                           ),
//                                           const SizedBox(
//                                             width: 150,
//                                           ),
//                                           const Icon(
//                                             Icons.save_rounded,
//                                             color: Colors.black,
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/1.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite1
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite1 = !favorite1;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Share.share('This is me');
// // },
// // icon: const Icon(Icons.share)),
// // const SizedBox(
// // width: 100,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'J Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/2.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite2
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite2 = !favorite2;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Share.share('This is me');
// // },
// // icon: const Icon(Icons.share)),
// // const SizedBox(
// // width: 100,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/3.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite3
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite3 = !favorite3;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/4.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite2
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite2 = !favorite2;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/5.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite3
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite3 = !favorite3;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/6.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite4
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite4 = !favorite4;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/7.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite5
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite5 = !favorite5;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/8.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite6
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite6 = !favorite6;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/9.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite7
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite7 = !favorite7;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),
// // const SizedBox(
// // height: 20,
// // ),
// // Container(
// // height:
// // MediaQuery.of(context).size.height / 2.5,
// // width: MediaQuery.of(context).size.width / 1.1,
// // decoration: BoxDecoration(
// // color:
// // const Color.fromARGB(255, 227, 225, 225),
// // // border:
// // //     Border.all(color: Colors.black, width: 2),
// // borderRadius: BorderRadius.circular(5),
// // ),
// // child: Column(
// // children: [
// // const Padding(
// // padding: EdgeInsets.all(8.0),
// // child: Text(
// // 'Japanes Convenience store will use VR controlled robots to stack shelves',
// // style: TextStyle(
// // fontWeight: FontWeight.bold),
// // ),
// // ),
// // SizedBox(
// // height: 200,
// // width: double.infinity,
// // child: Padding(
// // padding:
// // const EdgeInsets.only(top: 8.0),
// // child: Image.asset(
// // 'assets/images/10.jpg',
// // fit: BoxFit.cover,
// // ),
// // ),
// // ),
// // Row(
// // children: [
// // IconButton(
// // icon: Icon(
// // Icons.favorite,
// // size: 25,
// // color: favorite8
// // ? Colors.red
// //     : const Color.fromARGB(
// // 255, 114, 113, 113),
// // ),
// // onPressed: () {
// // setState(() {
// // favorite8 = !favorite8;
// // });
// // },
// // ),
// // const SizedBox(
// // width: 12,
// // ),
// // IconButton(
// // onPressed: () {
// // Navigator.push(
// // context,
// // MaterialPageRoute(
// // builder: (ctx) =>
// // const CommentPage()));
// // },
// // icon: const Icon(Icons.chat)),
// // const SizedBox(
// // width: 12,
// // ),
// // const Icon(
// // Icons.send,
// // color: Colors.black,
// // ),
// // const SizedBox(
// // width: 150,
// // ),
// // const Icon(
// // Icons.save_rounded,
// // color: Colors.black,
// // ),
// // ],
// // )
// // ],
// // )),

// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gridview/Services/notification_services.dart';
import 'package:gridview/pages/CommentsSection/comments_page.dart';
import 'package:gridview/pages/PostDetails/post_details.dart';
import 'package:gridview/pages/PostScreen/political_post.dart';
import 'package:gridview/pages/PostScreen/science_post.dart';
import 'package:gridview/pages/PostScreen/sports_post.dart';
import 'package:gridview/pages/PostScreen/technology_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String? username;
  String? email;
  bool favorite1 = false;
  bool favorite2 = false;
  bool favorite3 = false;
  bool favorite4 = false;
  bool favorite5 = false;
  bool favorite6 = false;
  bool favorite7 = false;
  bool favorite8 = false;
  bool favorite9 = false;
  bool favorite10 = false;
  bool favorite11 = false;

  _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get(const GetOptions(source: Source.cache))
        .then((snapshot) async {
      if (snapshot.exists &&
          snapshot.get('username') != null &&
          snapshot.get('email') != null) {
        setState(() {
          username = snapshot.data()!['username'];
          email = snapshot.data()!['email'];
        });
      } else {
        setState(() {
          username = snapshot.data()!['username'];
          email = snapshot.data()!['email'];
        });
      }
    });
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    _getDataFromDatabase();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getDeviceToken().then((value) {
      print('Device Token');
      print(value);
    });
    super.initState();
  }

  final searchController = TextEditingController();
  File? _image;
  String? imageURL;
  final picker = ImagePicker();
  String? name;

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        name = (_image!.path);
      }
    });
    Reference ref = FirebaseStorage.instance.ref().child(name.toString());

    await ref.putFile(File(_image!.path));
    ref.getDownloadURL().then((value) async {
      setState(() {
        imageURL = value;
      });
    });
  }

  final politicalgetdata =
      FirebaseFirestore.instance.collection('Political').snapshots();
  final technologygetdata =
      FirebaseFirestore.instance.collection('Technology').snapshots();
  final sciencegetdata =
      FirebaseFirestore.instance.collection('Science').snapshots();
  final sportsgetdata =
      FirebaseFirestore.instance.collection('Sports').snapshots();

  // ignore: non_constant_identifier_names
  Widget BottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 13,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getImageFromGallery();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          width: 280,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => BottomSheet());

                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref('/profile');

                          //print('uplaod profile');
                          firebase_storage.UploadTask uploadTask =
                              ref.putFile(_image!.absolute);
                          Navigator.pop(context);
                          Future.value(uploadTask).then((value) {
                            // ignore: unused_local_variable
                            var newUrl = ref.getDownloadURL();

                            // databaseRef
                            //     .child('1')
                            //     .set({'id': '1212', 'title': newUrl.toString()});

                            Fluttertoast.showToast(msg: 'Uploaded');
                          }).onError((error, stackTrace) {
                            Fluttertoast.showToast(
                                msg: 'Image Was Not Uploaded');
                          });
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.amber,
                          child: _image != null
                              ? ClipOval(
                                  child: Image.file(
                                    _image!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipOval(
                                  child:
                                      Image.asset('assets/images/empty.webp'),
                                ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: politicalgetdata,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return const Text('Some Error');
                            }
                            return Expanded(
                                child: SizedBox(
                              height: 100,
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, top: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          const Text(
                                            'Post',
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ))),
                            ));
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, bottom: 10, right: 150),
                  child: Text(
                    username.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, bottom: 10, right: 100),
                  child: Text(
                    email.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 179, 167, 166),
                  thickness: 1,
                ),

                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                //here is a divider
                ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: const Text('Polotical'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const PoliticalPost()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: ListTile(
                    title: const Text('Technology'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const TechnologyPost()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: ListTile(
                    title: const Text('Science'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const SciencePost()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55.0),
                  child: ListTile(
                    title: const Text('Sports'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const SportsPost()));
                    },
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 179, 167, 166),
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.face),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const PostDetails()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.device_unknown_outlined),
                  title: const Text('Help'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Apps & Tools'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          // leading: const Icon(Icons.menu),
          title: const Row(
            children: [
              Icon(
                Icons.face,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'reddit',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                onChanged: (String _) {
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Search .....",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  //fillColor: Vx.gray200,
                  filled: true,
                ),
              ),
            ),
            searchController.text.isEmpty
                ? Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        27.0,
                      ),
                    ),
                    child: TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.black,
                        indicatorWeight: 3,
                        controller: tabController,
                        tabs: const [
                          Tab(
                            child: Text(
                              'Politics',
                              style: TextStyle(
                                  fontFamily: 'Mirai Futura-Demo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Technology',
                              style: TextStyle(
                                  fontFamily: 'Mirai Futura-Demo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Science',
                              style: TextStyle(
                                  fontFamily: 'Mirai Futura-Demo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Sports',
                              style: TextStyle(
                                  fontFamily: 'Mirai Futura-Demo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11),
                            ),
                          )
                        ]),
                  )
                : Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('UserData')
                            .where('username',
                                isGreaterThanOrEqualTo: searchController.text)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const Text(
                              'No User Found',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 20),
                            );
                          } else {
                            var snap = snapshot.data!.docs;
                            return ListView(
                                children: List.generate(
                              snap.length,
                              (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Text(
                                        snapshot.data!.docs[index]['username']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ));
                          }
                        }),
                  ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: politicalgetdata,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Text('Some Error');
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          // print(
                                          //   snapshot.data!.docs[index]
                                          //       ['image_url'],
                                          // );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const PostDetails()));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 227, 225, 225),
                                              // border:
                                              //     Border.all(color: Colors.black, width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data!
                                                        .docs[index]['name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['recommendations']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['image_url']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    memCacheHeight: 220,
                                                    memCacheWidth: 220,
                                                    errorWidget: (context, _,
                                                            c) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    size: 25,
                                                    color: favorite1
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 114, 113, 113),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      favorite1 = !favorite1;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  const CommentPage()));
                                                    },
                                                    icon:
                                                        const Icon(Icons.chat)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Share.share('This is me');
                                                    },
                                                    icon: const Icon(
                                                        Icons.share)),
                                                const SizedBox(
                                                  width: 100,
                                                ),
                                                const Icon(
                                                  Icons.save_rounded,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ]),
                                            ])),
                                      );
                                    }),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: technologygetdata,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Text('Some Error');
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          // print(
                                          //   snapshot.data!.docs[index]
                                          //       ['image_url'],
                                          // );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const PostDetails()));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 227, 225, 225),
                                              // border:
                                              //     Border.all(color: Colors.black, width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data!
                                                        .docs[index]['name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['recommendations']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['image_url']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    memCacheHeight: 220,
                                                    memCacheWidth: 220,
                                                    errorWidget: (context, _,
                                                            c) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    size: 25,
                                                    color: favorite1
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 114, 113, 113),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      favorite1 = !favorite1;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  const CommentPage()));
                                                    },
                                                    icon:
                                                        const Icon(Icons.chat)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Share.share('This is me');
                                                    },
                                                    icon: const Icon(
                                                        Icons.share)),
                                                const SizedBox(
                                                  width: 100,
                                                ),
                                                const Icon(
                                                  Icons.save_rounded,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ]),
                                            ])),
                                      );
                                    }),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: sciencegetdata,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Text('Some Error');
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          // print(
                                          //   snapshot.data!.docs[index]
                                          //       ['image_url'],
                                          // );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const PostDetails()));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 227, 225, 225),
                                              // border:
                                              //     Border.all(color: Colors.black, width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data!
                                                        .docs[index]['name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['recommendations']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['image_url']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    memCacheHeight: 220,
                                                    memCacheWidth: 220,
                                                    errorWidget: (context, _,
                                                            c) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    size: 25,
                                                    color: favorite1
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 114, 113, 113),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      favorite1 = !favorite1;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  const CommentPage()));
                                                    },
                                                    icon:
                                                        const Icon(Icons.chat)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Share.share('This is me');
                                                    },
                                                    icon: const Icon(
                                                        Icons.share)),
                                                const SizedBox(
                                                  width: 100,
                                                ),
                                                const Icon(
                                                  Icons.save_rounded,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ]),
                                            ])),
                                      );
                                    }),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: sportsgetdata,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Text('Some Error');
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          // print(
                                          //   snapshot.data!.docs[index]
                                          //       ['image_url'],
                                          // );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const PostDetails()));
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2.25,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 227, 225, 225),
                                              // border:
                                              //     Border.all(color: Colors.black, width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 5),
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data!
                                                        .docs[index]['name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['recommendations']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['image_url']
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    memCacheHeight: 220,
                                                    memCacheWidth: 220,
                                                    errorWidget: (context, _,
                                                            c) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    size: 25,
                                                    color: favorite1
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 114, 113, 113),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      favorite1 = !favorite1;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  const CommentPage()));
                                                    },
                                                    icon:
                                                        const Icon(Icons.chat)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Share.share('This is me');
                                                    },
                                                    icon: const Icon(
                                                        Icons.share)),
                                                const SizedBox(
                                                  width: 100,
                                                ),
                                                const Icon(
                                                  Icons.save_rounded,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ]),
                                            ])),
                                      );
                                    }),
                              );
                            }
                          }),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
