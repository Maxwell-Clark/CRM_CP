import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class ChatBox extends ConsumerWidget {
  const ChatBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void sendText(String msg, TextEditingController textController) {
      textController.clear();
      AlanVoice.sendText(msg);
    }
    final textController = ref.watch(textControllerProvider);

    return Padding(padding: const EdgeInsets.only(bottom: 10, left: 10, right: 70, top: 10),
      child: TextField(
        controller: textController,
        cursorColor: primaryColor,
        style: const TextStyle(color: accentCanvasColor),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: accentCanvasColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          labelText: 'Ask something...',
          labelStyle: const TextStyle(color: accentCanvasColor),
          suffixIcon: IconButton(
            onPressed: () {
              sendText(textController.text, textController);
            },
            icon: const Icon(
              Icons.send,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}