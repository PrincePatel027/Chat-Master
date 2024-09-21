import 'package:bubbly_chatting/helper/firestore_db_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/firebase_messagin_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String recieverEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        toolbarHeight: 100,
        title: (FirebaseAuth.instance.currentUser?.email == recieverEmail)
            ? const Text("Yourself")
            : Text(
                'Chat App\n$recieverEmail',
              ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 14,
            child: Container(
              height: height,
              width: width,
              color: Colors.black12,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: FutureBuilder(
                future: FirestoreDbHelper.firestoreDbHelper
                    .fetchAllMessages(recieverEmail: recieverEmail),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    Stream? data = snapshot.data;
                    return StreamBuilder(
                      stream: data,
                      builder: (context, ss) {
                        if (ss.hasError) {
                          return Center(
                            child: Text("ERROR: ${ss.error}"),
                          );
                        } else if (ss.hasData) {
                          QuerySnapshot<Map<String, dynamic>>? chats = ss.data;

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allMessages = (chats == null) ? [] : chats.docs;

                          return (allMessages.isEmpty)
                              ? const Center(
                                  child: Text("No Messages Yet"),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  itemBuilder: (context, ind) {
                                    return Row(
                                      mainAxisAlignment: (recieverEmail !=
                                              allMessages[ind]
                                                  .data()['recieverEmail'])
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        (recieverEmail !=
                                                allMessages[ind]
                                                    .data()['recieverEmail'])
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey[400],
                                                ),
                                                child: Text(
                                                  allMessages[ind]
                                                      .data()['msg'],
                                                ),
                                              )
                                            : PopupMenuButton(
                                                onSelected: (value) async {
                                                  if (value == 'delete') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.blue[100],
                                                          title: const Text(
                                                              "Delete Message"),
                                                          content: const Text(
                                                              "Are you sure you want to delete this message?"),
                                                          actions: [
                                                            OutlinedButton.icon(
                                                              icon: const Icon(
                                                                  Icons.cancel),
                                                              label: const Text(
                                                                  "No"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            OutlinedButton.icon(
                                                              icon: const Icon(Icons
                                                                  .texture_outlined),
                                                              label: const Text(
                                                                  "Yes"),
                                                              onPressed:
                                                                  () async {
                                                                await FirestoreDbHelper
                                                                    .firestoreDbHelper
                                                                    .deleteChat(
                                                                  recieverEmail:
                                                                      recieverEmail,
                                                                  messageId:
                                                                      allMessages[
                                                                              ind]
                                                                          .id,
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if (value ==
                                                      "update") {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        TextEditingController
                                                            controller =
                                                            TextEditingController(
                                                          text: allMessages[ind]
                                                              .data()['msg'],
                                                        );
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors.blue[100],
                                                          title: const Text(
                                                            'Update Message',
                                                          ),
                                                          content: TextField(
                                                            controller:
                                                                controller,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Message',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            OutlinedButton(
                                                              child: const Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            OutlinedButton(
                                                              child: const Text(
                                                                  'Update'),
                                                              onPressed: () {
                                                                final updatedMessage =
                                                                    controller
                                                                        .text;
                                                                FirestoreDbHelper
                                                                    .firestoreDbHelper
                                                                    .updateMessage(
                                                                  updateMessage:
                                                                      updatedMessage,
                                                                  recieverEmail:
                                                                      recieverEmail,
                                                                  messageId:
                                                                      allMessages[
                                                                              ind]
                                                                          .id,
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                position:
                                                    PopupMenuPosition.under,
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: "update",
                                                    child: Text("Update"),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Text("Delete"),
                                                  ),
                                                ],
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.grey[400],
                                                  ),
                                                  child: Text(allMessages[ind]
                                                      .data()['msg']),
                                                ),
                                              )
                                      ],
                                    );
                                  },
                                  itemCount: allMessages.length,
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.1,
            color: Colors.black12,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: TextField(
              controller: msgController,
              onChanged: (value) {
                msgController.text = value;
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Send Message",
                border: const OutlineInputBorder(),
                suffixIcon:
                    (msgController.text == "" || msgController.text.isEmpty)
                        ? null
                        : IconButton(
                            onPressed: () async {
                              (msgController.text.isEmpty ||
                                      msgController.text == "")
                                  ? null
                                  : await FirestoreDbHelper.firestoreDbHelper
                                      .sendMessage(
                                      recieverEmail: recieverEmail,
                                      msg: msgController.text,
                                    );
                              // (msgController.text.isEmpty ||
                              //         msgController.text == "")
                              //     ? null
                              //     : FCMNotificationHelper.fCMNotificationHelper
                              //         .sendFCM(
                              //         msg: msgController.text,
                              //         senderEmail: recieverEmail,
                              //         token: await FirestoreDbHelper
                              //             .firestoreDbHelper
                              //             .getToken(recieverEmail: recieverEmail),
                              //       );
                              msgController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
