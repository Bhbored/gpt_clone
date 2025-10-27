import 'package:flutter/material.dart';
import 'package:gpt_clone/models/message.dart';
import 'package:gpt_clone/models/sender.dart';
import '../models/conversation.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  int _currentConversationIndex = 0;
  String apikey = "YOUR_API_KEY";
  String proxy = "";
  List<Conversation> get conversations => _conversations;
  int get currentConversationIndex => _currentConversationIndex;
  String get currentConversationTitle =>
      _conversations[_currentConversationIndex].title;
  int get currentConversationLength =>
      _conversations[_currentConversationIndex].messages.length;
  String get yourApiKey => apikey;
  String get yourProxy => proxy;
  Conversation get currentConversation =>
      _conversations[_currentConversationIndex];
  List<Map<String, String>> get currentConversationMessages {
    List<Map<String, String>> messages = [
      {'role': "system", 'content': ""},
    ];
    for (Message message
        in _conversations[_currentConversationIndex].messages) {
      messages.add({
        'role': message.senderId == 'User' ? 'user' : 'system',
        'content': message.content,
      });
    }
    return messages;
  }

  ConversationProvider() {
    _conversations.add(Conversation(messages: [], title: 'new conversation'));
  }
  set conversations(List<Conversation> value) {
    _conversations = value;
    notifyListeners();
  }

  set currentConversationIndex(int value) {
    _currentConversationIndex = value;
    notifyListeners();
  }

  set yourApiKey(String value) {
    apikey = value;
    notifyListeners();
  }

  set yourProxy(String value) {
    proxy = value;
    notifyListeners();
  }

  void addMessage(Message message) {
    _conversations[_currentConversationIndex].messages.add(message);
    notifyListeners();
  }

  void addEmptyConversation(String title) {
    if (title == '') {
      title = 'new conversation ${_conversations.length}';
    }
    _conversations.add(Conversation(messages: [], title: title));
    _currentConversationIndex = _conversations.length - 1;
    notifyListeners();
  }

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    _currentConversationIndex = _conversations.length - 1;
    notifyListeners();
  }

  void removeConversation(int index) {
    _conversations.removeAt(index);
    _currentConversationIndex = _conversations.length - 1;
    notifyListeners();
  }

  void removeCurrentConversation() {
    _conversations.removeAt(_currentConversationIndex);
    _currentConversationIndex = _conversations.length - 1;
    if (_conversations.isEmpty) {
      addEmptyConversation('');
    }
    notifyListeners();
  }

  void renameConversation(String title) {
    if (title == "") {
      title = 'new conversation $_currentConversationIndex';
    }
    _conversations[_currentConversationIndex].title = title;
    notifyListeners();
  }

  void clearConversations() {
    _conversations.clear();
    addEmptyConversation('');
    notifyListeners();
  }

  void clearCurrentConversation() {
    _conversations[_currentConversationIndex].messages.clear();
    notifyListeners();
  }
}

const String model = "gpt-3.5-turbo";
final Sender systemSender = Sender(
  name: 'System',
  avatarAssetPath: 'resources/avatars/ChatGPT_logo.png',
);
final Sender userSender = Sender(
  name: 'User',
  avatarAssetPath: 'resources/avatars/person.png',
);
