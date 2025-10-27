class Message {
  final String content;
  final DateTime timestamp;
  final String senderId;
  Message({required this.content, required this.senderId, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}
