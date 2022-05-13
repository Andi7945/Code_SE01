import 'package:code_se01/games/LightsOut.dart';
import 'package:code_se01/games/LightsOutAdvanced.dart';
import 'package:code_se01/games/TikTak.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'CODE SE01'),
        '/tiktak': (context) => const TikTak(),
        '/lightsout': (context) => const LightsOut(),
        '/lightsout_advanced': (context) => const LightsOutAdvanced(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to my mini Games',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/tiktak');
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                  ),
                ),
                child: const Center(child: Text("TikTac", style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/lightsout');
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                  ),
                ),
                child: const Center(child: Text("Lights Out", style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/lightsout_advanced');
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(15.0) //
                  ),
                ),
                child: const Center(child: Text("Lights Out Advanced", style: TextStyle(color: Colors.white),)),
              ),
            ),
          )

        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
