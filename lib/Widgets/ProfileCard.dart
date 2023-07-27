import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class ProfileCard extends StatefulWidget {
  final String title;
  final String data;
  final Function(String, String) onProfileDataChanged;

  ProfileCard({
    Key? key,
    required this.title,
    required this.data,
    required this.onProfileDataChanged,
  }) : super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          widget.title + " :",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blueGrey,
          ),
        ),
        subtitle: Text(
          widget.data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Edit ' + widget.title),
                  content: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: widget.data,
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          final newValue = _controller.text;
                          widget.onProfileDataChanged(widget.title, newValue);
                          firestore
                              .collection("users")
                              .doc(_auth.currentUser?.email)
                              .update({widget.title: newValue});
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}