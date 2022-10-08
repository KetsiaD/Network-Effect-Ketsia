import 'package:flutter/material.dart';
import 'package:ispy_game/server.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eye Spy"),
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Server(),
                ),
              );
            },
            child: const Text('Play Game'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Potential Scoring'),
          )
        ],
      ),
    )
    );
  }
}
