import 'dart:async';
import 'dart:developer';
import 'package:bubbly_chatting/helper/firebase_messagin_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDbHelper {
  FirestoreDbHelper._();
  static FirestoreDbHelper firestoreDbHelper = FirestoreDbHelper._();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  addAuthenticalUser({required String email}) async {
    bool isUserAlreadyExit = false;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList =
        querySnapshot.docs;
    for (var doc in docsList) {
      Map data = doc.data();
      if (data['email'] == email) {
        isUserAlreadyExit = true;
        break;
      }
    }

    if (isUserAlreadyExit == false) {
      DocumentSnapshot<Map<String, dynamic>> data =
          await db.collection("records").doc("users").get();
      int id = data['id'];
      int totalUsers = data['totalUsers'];
      id++;
      String? token =
          await FCMNotificationHelper.fCMNotificationHelper.getAccessToken();
      await db.collection("users").doc("$id").set({
        "email": email,
        "token": token,
      });
      totalUsers++;

      await db.collection("records").doc("users").update({
        "id": id,
        "totalUsers": totalUsers,
      });
      //
      log("User Added Succesfully...");
    } else {
      log("User Already Exists...");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection("users").snapshots();
  }

  deleteUser({required String id}) async {
    await db.collection("users").doc(id.toString()).delete();
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection("records").doc("users").get();
    int counter = userDoc.data()!['totalUsers'];
    counter--;
    await db.collection("records").doc("users").update({
      "totalUsers": counter,
    });
  }

  updateMessage(
      {required String updateMessage,
      required String recieverEmail,
      required String messageId}) async {
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }
    await db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .update({
      "msg": updateMessage,
      "updatedTime": FieldValue.serverTimestamp(),
    });
  }

  deleteChat({required String recieverEmail, required String messageId}) async {
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }
    await db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  sendMessage({required String recieverEmail, required String msg}) async {
    bool isChatRoomExists = false;
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;
    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        isChatRoomExists = true;
        chatRoomId = chatrooms.id;
        break;
      }
    }
    if (isChatRoomExists == false) {
      DocumentReference<Map<String, dynamic>> ref =
          await db.collection("chatrooms").add({
        "users": [senderEmail, recieverEmail],
        "token":
            await FCMNotificationHelper.fCMNotificationHelper.fetchFMCToken(),
      });
      chatRoomId = ref.id;
      // Update data when user start chat....
    }
    await db.collection("chatrooms").doc(chatRoomId).update(
      {
        "users": [senderEmail, recieverEmail],
        "token":
            await FCMNotificationHelper.fCMNotificationHelper.fetchFMCToken(),
      },
    );
    await db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .add({
      "msg": msg,
      "senderEmail": senderEmail,
      "recieverEmail": recieverEmail,
      "timeStamp": FieldValue.serverTimestamp(),
    });
  }

  getToken({required String recieverEmail}) async {
    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;
    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("chatrooms").doc(chatRoomId).get();
    String token = snapshot.data()!['token'];
    return token;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchAllMessages(
      {required String recieverEmail}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("chatrooms").get();

    String? chatRoomId;
    String? senderEmail = FirebaseAuth.instance.currentUser?.email;

    List<QueryDocumentSnapshot<Map<String, dynamic>>> allChatrooms =
        querySnapshot.docs;

    for (var chatrooms in allChatrooms) {
      List<String> users = chatrooms.data()['users'].cast<String>();
      if (users.contains(recieverEmail) && users.contains(senderEmail)) {
        chatRoomId = chatrooms.id;
        break;
      }
    }

    return db
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy(
          "timeStamp",
          descending: true,
        )
        .snapshots();
  }
}
