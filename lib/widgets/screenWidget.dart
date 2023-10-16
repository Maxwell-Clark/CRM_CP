import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:crm_copilot/screens/chatscreen.dart';
import 'package:crm_copilot/widgets/chatbox.dart';

import '../models/ChatModel.dart';



class ScreenWidget extends ConsumerWidget {
  const ScreenWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final messages = ref.watch(messagesProvider).messages;
    final previousMessageCount = messages.length;
    final scrollController = ScrollController();

    print('MESSAGE LENGTH ${messages.length} and ${previousMessageCount}');

    // if (messages.length > previousMessageCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    // }
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final pageTitle = _getTitleByIndex(controller.selectedIndex);
                  switch (controller.selectedIndex) {
                    case 0:
                      return  ChatListView(
                        scrollController: scrollController
                      );
                    default:
                      return Text(
                        pageTitle,
                        style: theme.textTheme.headlineSmall,
                      );
                  }
                },
              ),
            ),
          ),
          const ChatBox()
        ],
      ),
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'CRM CP';
    case 1:
      return 'Dashboard';
    case 2:
      return 'Contacts';
    case 3:
      return 'Leads';
    case 4:
      return 'Tasks';
    case 5:
      return 'Deals';
    case 6:
      return 'Reports';
    case 7:
      return 'Opportunities';
    case 8:
      return 'Settings';
    default:
      return 'Not found page';
  }
}
