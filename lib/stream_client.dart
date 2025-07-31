import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StreamClientProvider {
  static final StreamChatClient client = StreamChatClient(
    dotenv.env['STREAM_API_KEY']!,
    logLevel: Level.INFO,
  );

  /// Connect a user to the Stream Chat client (production, fetch token from backend)
  static Future<void> connectUser(String userId, {String? name}) async {
    if (client.state.currentUser?.id == userId) return;
    await client.disconnectUser();
    // Fetch token from backend
    final tokenEndpoint = dotenv.env['TOKEN_ENDPOINT'] ?? 'http://localhost:3000/token';
    final response = await http.get(Uri.parse('$tokenEndpoint?user_id=$userId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch Stream Chat token: ${response.body}');
    }
    final token = jsonDecode(response.body)['token'];
    await client.connectUser(
      User(id: userId, name: name ?? userId),
      token,
    );
  }
}
