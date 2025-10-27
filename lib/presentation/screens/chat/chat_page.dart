import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gpt_clone/models/sender.dart';
import 'package:gpt_clone/providers/conversation_provider.dart';
import 'package:provider/provider.dart';

import '../../styles/app_theme.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/input_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final HttpClient _client = HttpClient();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _client.close();
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ==== BUSINESS LOGIC (unchanged from your version) ====
  Future<Message?> _sendMessage(List<Map<String, String>> messages) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey = Provider.of<ConversationProvider>(
      context,
      listen: false,
    ).yourApiKey;
    final proxy = Provider.of<ConversationProvider>(
      context,
      listen: false,
    ).yourProxy;
    final converter = JsonUtf8Encoder();

    if (proxy != "") {
      _client.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(
          url,
          environment: {"http_proxy": proxy, "https_proxy": proxy},
        );
      };
    }

    try {
      final body = {'model': model, 'messages': messages};
      return await _client
          .postUrl(url)
          .then((HttpClientRequest request) {
            request.headers.set('Content-Type', 'application/json');
            request.headers.set('Authorization', 'Bearer $apiKey');
            request.add(converter.convert(body));
            return request.close();
          })
          .then((HttpClientResponse response) async {
            final retBody = await response.transform(utf8.decoder).join();
            if (response.statusCode == 200) {
              final data = json.decode(retBody);
              final completions = data['choices'] as List<dynamic>;
              if (completions.isNotEmpty) {
                final completion = completions[0];
                final content = (completion['message']['content'] as String)
                    .replaceFirst(RegExp(r'^\n+'), '');
                return Message(senderId: systemSender.id, content: content);
              }
            } else {
              return Message(
                content: "API KEY is Invalid",
                senderId: systemSender.id,
              );
            }
            return null;
          });
    } on Exception catch (e) {
      return Message(content: e.toString(), senderId: systemSender.id);
    }
  }

  void _scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _sendMessageAndAddToChat() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final userMessage = Message(senderId: userSender.id, content: text);

    setState(() {
      Provider.of<ConversationProvider>(
        context,
        listen: false,
      ).addMessage(userMessage);
    });

    _scrollToLastMessage();

    final assistantMessage = await _sendMessage(
      Provider.of<ConversationProvider>(
        context,
        listen: false,
      ).currentConversationMessages,
    );

    if (assistantMessage != null) {
      setState(() {
        Provider.of<ConversationProvider>(
          context,
          listen: false,
        ).addMessage(assistantMessage);
      });
    }

    _scrollToLastMessage();
  }

  @override
  Widget build(BuildContext context) {
    final canSend =
        Provider.of<ConversationProvider>(context, listen: true).yourApiKey !=
        "YOUR_API_KEY";

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('U-Clone Chat'),
          backgroundColor: Colors.black.withOpacity(0.15),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ConversationProvider>(
                builder: (context, conversationProvider, child) {
                  final items =
                      conversationProvider.currentConversation.messages;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final msg = items[index];
                      final isUser = msg.senderId == userSender.id;

                      // Row with optional avatars kept, but simplified visually
                      return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isUser)
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      systemSender.avatarAssetPath,
                                    ),
                                    radius: 14,
                                  )
                                else
                                  const SizedBox(width: 28),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: MessageBubble(
                                    message: msg,
                                    isUser: isUser,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (isUser)
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                      userSender.avatarAssetPath,
                                    ),
                                    radius: 14,
                                  )
                                else
                                  const SizedBox(width: 28),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 280.ms, curve: Curves.easeOut)
                          .moveY(
                            begin: 6,
                            end: 0,
                            duration: 280.ms,
                            curve: Curves.easeOut,
                          );
                    },
                  );
                },
              ),
            ),

            InputBar(
              controller: _textController,
              enabled: true,
              onSend: canSend
                  ? () {
                      _focusNode.unfocus();
                      _sendMessageAndAddToChat();
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please set a valid API key first.'),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
