import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  ChatMessage({
    required this.text,
    this.isReceived = true
  });

  final String text;
  final bool isReceived;
}

class MessageNotifier extends ChangeNotifier {
  final messages = <ChatMessage>[];

  void addUserMessage(ChatMessage msg) {
    messages.add(msg);
  }

  void addResponseMessage(ChatMessage msg) {
    messages.add(msg);
    notifyListeners();
  }

}

final messagesProvider = ChangeNotifierProvider<MessageNotifier>((ref) {
  return MessageNotifier();
});
