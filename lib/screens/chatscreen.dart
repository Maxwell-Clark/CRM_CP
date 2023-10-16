import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../models/ChatModel.dart';

class ChatListView extends ConsumerWidget {
  const ChatListView({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider).messages;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 18),
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Align(
          alignment: message.isReceived ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            key: UniqueKey(),
            padding: const EdgeInsets.all(15),  // Adjust as necessary
            margin: message.isReceived
                ? EdgeInsets.only(bottom: 10, left: 10, right: 50)
                : EdgeInsets.only(bottom: 10, right: 10, left: 50),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,  // Use 70% of screen width
              minWidth: MediaQuery.of(context).size.width * 0.4,  // Use 20% of screen width (minimum
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.isReceived
                  ? Theme.of(context).canvasColor
                  : primaryColor,
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                color: accentCanvasColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}