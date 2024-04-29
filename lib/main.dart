import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(
        channel: IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final WebSocketChannel channel;
  const Home({required this.channel, super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          centerTitle: true,
          title: const Text(
            "WebSocket Example",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: editingController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5.0),
                  hintText: "Enter Message to send the server",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapsort) {
                  return Text(
                    snapsort.hasData ? '${snapsort.data}' : 'Enter message',
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              sendMessage();
            },
            label: const Icon(Icons.send)),
      ),
    );
  }

  // to send the data
  void sendMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  // to close the connection
  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
