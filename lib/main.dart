import 'package:crm_copilot/widgets/screenWidget.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_svg/flutter_svg.dart';




import 'models/ChatModel.dart';
part 'main.g.dart';


@riverpod
String alanResponse(ref) {
  return 'hello world';
}

@riverpod
TextEditingController textController( ref) {
  final controller = TextEditingController();
  return controller;
}

final sidebarControllerProvider = StateProvider.autoDispose<SidebarXController>(
      (ref) => SidebarXController(selectedIndex: 0, extended: false),
);

final scaffoldKeyProvider = Provider.autoDispose<GlobalKey<ScaffoldState>>(
      (ref) => GlobalKey<ScaffoldState>(),
);

final processedEvents = <String>{};

final String assetName = 'assets/images/brain.svg';
final Widget brain_svg = SvgPicture.asset(
  assetName,
  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
  semanticsLabel: 'CRM Logo'
);


void main() {
  runApp(
      ProviderScope(
        child: CRMCoPilotApp(),
      ),
    );
}


class CRMCoPilotApp extends ConsumerWidget {
  const CRMCoPilotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messagesProvider);
    final _controller = ref.watch(sidebarControllerProvider);
    final _key = ref.watch(scaffoldKeyProvider);
    AlanVoice.addButton(
        "267de43e1e45fb3c51eb67213af582d72e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

    AlanVoice.onEvent.add((event) {
      final requestId = event.data['ctx']?['reqId']?.toString() ?? event.data['reqId']?.toString();
      final eventName = event.data['name']?.toString();

      final uniqueId = '$requestId-$eventName';

      print('PRINT!!!!!! EVENT!!!! ${uniqueId}');
      var messagesToAdd = [];

      if (!processedEvents.contains(uniqueId)) {
        if(eventName == 'parsed') {
          final parsed_value = event.data['text']?.toString() ?? '';
          print('PRINT!!!!!! PARSED VALUE!!!! ${parsed_value}');
          if(parsed_value.isNotEmpty) {
            messages.addUserMessage(ChatMessage(text: parsed_value, isReceived: false));
            processedEvents.add(uniqueId);
          }
        } else if (eventName == 'text') {
          final response_value = event.data['text']?.toString() ?? '';
          if(response_value.isNotEmpty) {
            print('PRINT!!!!!! RESPONSE!!!! ${response_value}');
            messages.addResponseMessage(ChatMessage(text: response_value));
            processedEvents.add(uniqueId);
          }
        }
      }
    });

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });
    return MaterialApp(
      title: 'CRM CoPilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
              backgroundColor: Color(0x44141718),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                )
                ),
              leading: IconButton(
                onPressed: () {
                  // if (!Platform.isAndroid && !Platform.isIOS) {
                  //   _controller.setExtended(true);
                  // }
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
              actions: const [
                Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Text('MC'),
                    ),
                )
              ],
            )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: ScreenWidget(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: sidebarColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sidebarColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [primaryColor, primaryColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: sidebarColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: brain_svg,
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'CRM CP',
          onTap: () {
            debugPrint('CRM CoPilot');
          },
        ),
        SidebarXItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
          onTap: () {
            debugPrint('Opening Dashboard');
          },
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Contacts',
          onTap: () {
            debugPrint('Opening Contacts');
          },
        ),
        SidebarXItem(
          icon: Icons.leaderboard,
          label: 'Leads',
          onTap: () {
            debugPrint('Opening Leads');
          },
        ),
        SidebarXItem(
          icon: Icons.assignment_turned_in,
          label: 'Tasks',
          onTap: () {
            debugPrint('Opening Tasks');
          },
        ),
        SidebarXItem(
          icon: Icons.business_center,
          label: 'Deals',
          onTap: () {
            debugPrint('Opening Deals');
          },
        ),
        SidebarXItem(
          icon: Icons.insert_chart_outlined,
          label: 'Reports',
          onTap: () {
            debugPrint('Opening Reports');
          },
        ),
        SidebarXItem(
          icon: Icons.mail_outline,
          label: 'Opportunities',
          onTap: () {
            debugPrint('Opening Opportunities');
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            debugPrint('Opening Settings');
          },
        ),
      ],
    );
  }
}

const primaryColor = Color(0xFF8E55EA);
const canvasColor = Color(0xFF6C7275);
const scaffoldBackgroundColor = Color(0xFF141718);
const sidebarColor = Color(0xFF232627);
const accentCanvasColor = Color(0xFFE8ECEF);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);