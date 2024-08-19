import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  late Gemini gemini;

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  void initState() {
    super.initState();
    // Initialize the Gemini instance with the API key
    Gemini.init(
        apiKey:
            'AIzaSyCFWHHksf9tiH5HHJNR_Gdo17Jdhd7gKZw'); // Replace 'your_api_key_here' with your actual API key
    gemini = Gemini.instance;
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = ChatMessage(
      user: currentUser,
      text: _controller.text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMessage);
      _isLoading = true;
    });

    _controller.clear();

    try {
      gemini.streamGenerateContent(userMessage.text).listen((event) {
        final parts = event.content?.parts;

        if (parts != null) {
          final responseText = parts.fold(
              "", (previous, current) => "$previous ${current.text}");

          final botMessage = ChatMessage(
            user: geminiUser,
            text: responseText.trim(),
            createdAt: DateTime.now(),
          );

          setState(() {
            _messages.insert(0, botMessage);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with MARCO'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DashChat(
              currentUser: currentUser,
              onSend: (ChatMessage message) {
                _sendMessage();
              },
              messages: _messages,
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
