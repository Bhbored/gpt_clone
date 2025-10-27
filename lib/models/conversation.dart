import 'package:gpt_clone/models/sender.dart';

class Conversation {
  final List<Message> messages;
  String title;
  Conversation({required this.messages, required this.title});
}
