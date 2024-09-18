import 'package:bubbly_chatting/helper/firebase_helper.dart';
import 'package:bubbly_chatting/helper/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  const MyDrawer({super.key, required this.user});

  @override
  State<MyDrawer> createState() => _DrawersState();
}

class _DrawersState extends State<MyDrawer> {
  ImagePicker picker = ImagePicker();

  updateProfilePic() async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      try {
        widget.user.updatePhotoURL(file.path.toString());
      } catch (e) {
        UiHelper.showCustomDialog(context: context, title: e.toString());
      }
    }
  }

  TextEditingController? nameController;

  Future<void> updateProfileName() async {
    nameController = TextEditingController(text: widget.user.displayName);
    final String? newName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Profile Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'New Profile Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController != null) {
                Navigator.of(context).pop(nameController!.text);
              } else {
                UiHelper.showCustomDialog(
                    context: context, title: "Please enter name first");
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      try {
        await widget.user.updateDisplayName(newName);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile name updated successfully')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  Future updatePassword() async {
    final bool? confirmUpdate = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == confirmPasswordController.text) {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmUpdate == true) {
      try {
        await widget.user.updatePassword(passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: ${e.message}')),
        );
      }
    }
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isAnonymous() {
    return widget.user.isAnonymous;
  }

  // bool isGoogleSignIn() {
  //   for (var data in widget.user.providerData) {
  //     data.providerId == "google.com";
  //     return false;
  //   }
  //   return true;
  // }

  bool isGoogleSignIn() {
    return widget.user.providerData
        .any((data) => data.providerId == "google.com");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: (widget.user.isAnonymous)
                      ? null
                      : (widget.user.photoURL == null)
                          ? null
                          : NetworkImage(widget.user.photoURL!),
                ),
                const SizedBox(height: 12),
                Text(
                  (nameController?.text == null)
                      ? widget.user.displayName ?? 'No User Name'
                      : nameController!.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.email ?? 'user.email@example.com',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          (!isAnonymous() && !isGoogleSignIn())
              ? ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Change Username'),
                  onTap: updateProfileName,
                )
              : Container(),
          (!isAnonymous() && !isGoogleSignIn())
              ? ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: updatePassword,
                )
              : Container(),
          (!isAnonymous() && !isGoogleSignIn())
              ? ListTile(
                  leading: const Icon(Icons.image_rounded),
                  title: const Text('Add Image'),
                  onTap: updateProfilePic,
                )
              : Container(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Do you want to logout..."),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseHelper.firebaseHelper.signOutUser();
                        Navigator.of(context).pushReplacementNamed('login');
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
