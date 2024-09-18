import 'package:bubbly_chatting/helper/firebase_messagin_helper.dart';
import 'package:bubbly_chatting/helper/firestore_db_helper.dart';
import 'package:bubbly_chatting/views/components/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // LNotificationHelper.lNotificationHelper.showLocalNotification(
    //   title: "First",
    //   body: "This is first notification...",
    // );
    FCMNotificationHelper.fCMNotificationHelper.fetchFMCToken();
  }

  @override
  Widget build(BuildContext context) {
    // User user = ModalRoute.of(context)!.settings.arguments as User;
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home Page"),
      ),
      drawer: (user == null)
          ? const Drawer()
          : MyDrawer(
              user: user,
            ),
      body: SizedBox(
        height: height,
        width: width,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/photos/bgL.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: StreamBuilder(
          stream: FirestoreDbHelper.firestoreDbHelper.fetchAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              List allDocs = (data == null) ? [] : data.docs;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "chat",
                        arguments: allDocs[index].data()['email'],
                      );
                    },
                    leading: const CircleAvatar(),
                    title: (FirebaseAuth.instance.currentUser?.email ==
                            allDocs[index].data()['email'])
                        ? Text("You ~(${allDocs[index].data()['email']})")
                        : Text(
                            allDocs[index].data()['email'],
                          ),
                    // trailing: (user!.email! != allDocs[index].data()['email'])
                    //     ? null
                    //     : IconButton(
                    //         onPressed: () {
                    //           // FirestoreDbHelper.firestoreDbHelper.deleteUser(
                    //           //   id: allDocs[index].id,
                    //           // );
                    //           showDialog(
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               return AlertDialog(
                    //                 title: const Text('Confirm Deletion'),
                    //                 content: Text(
                    //                     'Are you sure you want to delete this ${allDocs[index].data()['email']}?'),
                    //                 actions: [
                    //                   OutlinedButton(
                    //                     child: const Text('Cancel'),
                    //                     onPressed: () {
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   ),
                    //                   OutlinedButton(
                    //                     child: const Text('Delete'),
                    //                     onPressed: () {
                    //                       FirestoreDbHelper.firestoreDbHelper
                    //                           .deleteUser(
                    //                         id: allDocs[index].id,
                    //                       );
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   ),
                    //                 ],
                    //               );
                    //             },
                    //           );
                    //         },
                    //         icon: const Icon(
                    //           Icons.delete,
                    //           color: Colors.red,
                    //         ),
                    //       ),
                  );
                },
                itemCount: allDocs.length,
              );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }
}
