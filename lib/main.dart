import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'stream_client.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/doctor/doctor_home_screen.dart';
import 'screens/patient/patient_home_screen.dart';

import 'screens/shared/video_call_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(MedTalkApp());
}

class MedTalkApp extends StatelessWidget {
  MedTalkApp({super.key});

  final StreamChatClient client = StreamClientProvider.client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedTalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/doctor': (context) => const DoctorHomeScreen(),
        '/patient': (context) => const PatientHomeScreen(),
        '/video': (context) => const VideoCallScreen(participantName: 'Dr. Sarah Lee'),
      },
      builder: (context, child) => StreamChat(
        client: client,
        child: child!,
      ),
    );
  }
}

