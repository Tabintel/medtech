import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../stream_client.dart';
import '../../demo_users.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  late final StreamChannelListController _channelListController;

  @override
  void initState() {
    super.initState();
    _channelListController = StreamChannelListController(
      client: StreamClientProvider.client,
      filter: Filter.in_('members', [StreamClientProvider.client.state.currentUser!.id]),
      limit: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamClientProvider.client.state.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Doctor', style: TextStyle(color: Color(0xFF2A4D9B), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF2A4D9B)),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Patient list
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: demoPatients.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final patient = demoPatients[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final client = StreamClientProvider.client;
                              final currentUser = client.state.currentUser;
                              
                              if (currentUser == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Current user not found. Please log in again.')),
                                );
                                return;
                              }
                              try {
                                // Create the channel
                                final channel = client.channel(
                                  'messaging',
                                  extraData: {
                                    'members': [currentUser.id, patient.id],
                                    'created_by_id': currentUser.id,
                                  },
                                );
                                
                                // Create the channel on Stream
                                await channel.create();
                                
                                // Navigate to the chat
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StreamChannel(
                                      channel: channel,
                                      child: const StreamChannelPage(),
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error creating chat: ${e.toString()}')),
                                );
                              }
                            },
                            child: const Text('Start Chat'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Chat list
            Expanded(
              child: StreamChannelListView(
                controller: _channelListController,
                onChannelTap: (channel) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StreamChannel(
                        channel: channel,
                        child: const StreamChannelPage(),
                      ),
                    ),
                  );
                },
                emptyBuilder: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFF2A4D9B)),
                      SizedBox(height: 16),
                      Text('No active chats yet', style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StreamChannelPage extends StatelessWidget {
  const StreamChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: const [
          Expanded(child: StreamMessageListView()),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
