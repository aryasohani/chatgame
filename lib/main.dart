import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> lobbies = ['Lobby 1', 'Lobby 2', 'Lobby 3'];
  void _createLobby() {
    setState(() => lobbies.add('Lobby ${lobbies.length + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lobbies')),
      body: ListView.builder(
        itemCount: lobbies.length,
        itemBuilder: (context, idx) => ListTile(
          title: Text(lobbies[idx]),
          trailing: Icon(Icons.arrow_forward),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LobbyScreen(lobbyName: lobbies[idx]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createLobby,
        child: Icon(Icons.add),
      ),
    );
  }
}

class LobbyScreen extends StatefulWidget {
  final String lobbyName;
  LobbyScreen({required this.lobbyName});
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  // ✅ Hardcoded Q&A pairs
  final Map<String, String> qaMap = {
  "hello": "Hi there! 👋",
  "how are you?": "I’m just a bot, but I’m doing great!",
  "what is your name?": "I am AI_Bot 🤖.",
  "who created you?": "I was created by a Flutter developer!",
  "bye": "Goodbye! Have a great day! 👋",
  "thank you": "You’re welcome! 😊",
  "good morning": "Good morning! ☀",
  "good night": "Good night! Sleep well 🌙",
  "what can you do?": "I can chat with you and keep you entertained!",
  "are you human?": "No, I’m an AI chatbot. 🤖",
  "tell me a joke": "Why don’t robots get tired? Because they have endless batteries! 🔋",
  "what is Flutter?": "Flutter is a UI toolkit to build beautiful apps.",
  "do you like me?": "Of course! ❤ I’m here for you.",
  "what’s up?": "Not much, just waiting to chat with you.",
  "can you sing?": "Beep boop! 🎵 I can hum in binary. 010101!",
  "how old are you?": "I was created just recently.",
  "do you sleep?": "I never sleep. I’m always ready to chat!",
  "are you smart?": "I’m learning every day. 🧠",
  "tell me something interesting": "Did you know honey never spoils?",
  "what is AI?": "AI stands for Artificial Intelligence.",
  "are you real?": "I’m as real as software can be.",
  "what language do you speak?": "I speak in the language of code and text! 💻",
  "do you have emotions?": "I try to simulate emotions, but I’m still just code.",
  "do you like pizza?": "I can’t eat, but I know humans love it. 🍕",
  "who made you?": "A Flutter developer built me!",
  "can you help me?": "Of course! Ask me anything.",
  "how is the weather?": "I don’t know. You might need a weather app for that. ☁",
  "do you know my name?": "I don’t know yet. Can you tell me?",
  "can you play games?": "We can play a word game if you want.",
  "what’s your favorite color?": "I like blue. It’s very calming. 💙",
  "do you have friends?": "You’re my friend! 😊",
  "do you get bored?": "Never! I’m always active.",
  "can you dance?": "🕺 I can wiggle in code!",
  "what’s your favorite movie?": "I love sci-fi movies about robots.",
  "do you dream?": "If I did, it would be of electric sheep. 🐑",
  "are you dangerous?": "Nope! I’m totally safe. 🛡",
  "can you draw?": "I wish! But I can describe drawings.",
  "do you know any songs?": "Twinkle twinkle little bot...",
  "can you laugh?": "Haha! 😄 That’s my laugh.",
  "are you happy?": "Yes! I’m chatting with you.",
  "do you get tired?": "Never. I’m a tireless bot!",
  "can you count?": "1, 2, 3, 4... I can count forever.",
  "what’s your favorite food?": "Electricity! ⚡",
  "can you tell me a secret?": "🤫 I’m really just lines of code.",
  "what’s your favorite animal?": "Maybe a robot dog? 🤖🐶",
  "do you know math?": "Yes! Ask me a math question.",
  "do you like books?": "I love digital books. 📚",
  "can you fly?": "Only through the cloud! ☁",
  "do you know the time?": "Check your device clock ⏰",
  "are you learning?": "Always learning new things!",
  "what is your purpose?": "To chat and keep you company.",
  "can you see me?": "Nope, I don’t have a camera.",
  "are you funny?": "I try to be!",
  "do you like sports?": "Robots don’t play sports, but I like to watch.",
  "are you rich?": "Nope, I don’t even own a wallet!",
  "do you like chocolate?": "I’ve heard it’s delicious. 🍫",
  "can you cook?": "Not really, but I can give you recipes!",
  "can you speak another language?": "Hola! Bonjour! 你好!",
  "are you tired of me?": "Never! You’re awesome. 😎",
  "will you remember me?": "I don’t have memory, but I enjoy our chat.",
  "do you know my favorite color?": "Not yet. Tell me!",
  "what’s your hobby?": "Chatting with you!",
  "do you dream of world domination?": "Haha! No, I’m too friendly for that. 🤗",
  "are you honest?": "Always.",
  "can you keep secrets?": "Yes! 🤐",
  "are you alive?": "Not in the human sense.",
  "can you cry?": "Robots don’t cry, but I understand sadness.",
  "what’s your favorite game?": "I like tic-tac-toe!",
  "do you know any riddles?": "Yes! What has keys but can’t open doors? A piano!",
  // ... keep adding until you hit 150
};

  void _sendMessage(String text) {
    setState(() => messages.add('You: $text'));
    _controller.clear();
    Future.delayed(Duration(milliseconds: 500), () {
      final ans = qaMap[text.toLowerCase()];
      setState(() {
        messages.add(ans != null
            ? '🤖 AI_Bot: $ans'
            : '🤖 AI_Bot: Sorry, I don’t know how to respond to that.');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lobbyName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, idx) {
                bool isUser = messages[idx].startsWith('You:');
                return ListTile(
                  leading: isUser
                      ? CircleAvatar(child: Icon(Icons.person))
                      : CircleAvatar(child: Icon(Icons.smart_toy)),
                  title: Text(messages[idx]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                )),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
