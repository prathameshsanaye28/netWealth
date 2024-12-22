class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final String messageId;
  final DateTime timestamp;
  final String? imageUrl;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageId,
    required this.timestamp,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'messageId': messageId,
    'timestamp': timestamp.toIso8601String(),
    'imageUrl': imageUrl,
  };

  static Message fromSnap(Map<String, dynamic> snap) {
    return Message(
      senderId: snap['senderId'],
      receiverId: snap['receiverId'],
      message: snap['message'],
      messageId: snap['messageId'],
      timestamp: DateTime.parse(snap['timestamp']),
      imageUrl: snap['imageUrl'],
    );
  }
}