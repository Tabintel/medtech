import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../stream_client.dart';

class ChatScreen extends StatefulWidget {
  final String channelId;
  final String userId;
  const ChatScreen({super.key, required this.channelId, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Channel channel;

  @override
  void initState() {
    super.initState();
    channel = StreamClientProvider.client.channel(
      'messaging',
      id: widget.channelId,
      extraData: {'members': [widget.userId]},
    );
    channel.watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Scaffold(
        appBar: StreamChannelHeader(),
        body: Column(
          children: [
            Expanded(child: StreamMessageListView()),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }
}
