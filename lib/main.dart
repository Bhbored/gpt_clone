import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/chat/chat_page.dart';
import 'presentation/widgets/drawer.dart';
import 'providers/conversation_provider.dart';
import 'presentation/widgets/pop_menu.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConversationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData(
    primarySwatch: Colors.grey,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            Provider.of<ConversationProvider>(
              context,
              listen: true,
            ).currentConversationTitle,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: 'din-regular',
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          toolbarHeight: 50,
          actions: const [CustomPopupMenu()],
        ),
        drawer: const MyDrawer(),
        body: const Center(child: ChatPage()),
      ),
    );
  }
}
