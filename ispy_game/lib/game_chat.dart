import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:ispy_game/image_selection_screen.dart';
import 'package:ispy_game/scoring.dart';
import 'friends.dart';
import 'takepictureScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.friend});

  final Friend? friend;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const List<String> list = <String>['Correct', 'Incorrect'];
  String dropdownValue = list.first;
  final Scoring score = Scoring();

  // Text input window when guessing or responding
  Future<void> _displayRespondToGuessDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Respond to Guess'),
          content: Column(
            children: [
              DropdownButtonFormField<String>(
                value: dropdownValue,
                style: const TextStyle(color: Colors.deepPurple),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                onSaved: (String? value) {
                  // This is called when the selection is saved.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                key: const Key("CancelButtonDropdown"),
                child: const Text('Cancel'),
                onPressed: () {
                  setState(
                    () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              ElevatedButton(
                key: const Key("OKButtonDropdown"),
                child: const Text('OK'),
                onPressed: () {
                  setState(
                    () {
                      //send(dropdownValue);
                      if (dropdownValue == 'Correct') {
                        widget.friend?.score += 1;
                        //   print("Correct");
                        //Get the friend and update subtitles map in scoring
                        //score.subtitles[score.index(friend.name)] = 1;
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void initState() {
    super.initState();
    widget.friend!.addListener(update);
  }

  void dispose() {
    widget.friend!.removeListener(update);
    print("Goodbye");
    super.dispose();
  }

  void update() {
    print("New message!");
    setState(() {});
  }

  Future<void> send(Image msg) async {
    await widget.friend!.send(msg).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat with ${widget.friend!.name}"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final result = await availableCameras().then((value) =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TakePictureScreen(
                                      camera: value.first,
                                      friend: widget.friend))));
                    },
                    child: const Text("Share an Image"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _displayRespondToGuessDialog(context);
                    },
                    child: const Text("Respond to a Guess"),
                  ),
                ),
              ],
            ),
            Expanded(child: widget.friend!.bubble_history()),
            MessageBar(
              onSend: (_) {},
            )
          ],
        ),
      ),
    );
  }
}
