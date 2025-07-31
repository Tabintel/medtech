import 'package:flutter/material.dart';

class VideoCallScreen extends StatelessWidget {
  final String participantName;
  const VideoCallScreen({super.key, required this.participantName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Call with $participantName')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, size: 100, color: Colors.blue),
            const SizedBox(height: 24),
            Text('Connecting to $participantName...', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic_off),
                  iconSize: 36,
                  onPressed: () {},
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.videocam_off),
                  iconSize: 36,
                  onPressed: () {},
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  iconSize: 36,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
