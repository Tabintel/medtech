import 'package:flutter/material.dart';
import '../../stream_client.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _loading = false;

  Future<void> _connectAndNavigate(String userId, String route, {String? name}) async {
    setState(() => _loading = true);
    await StreamClientProvider.connectUser(userId, name: name);
    setState(() => _loading = false);
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/medtalk_logo.png',
                height: 120,
              ),
              const SizedBox(height: 32),
              const Text(
                'MedTalk',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2A4D9B)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Talk to a doctor anytime, anywhere',
                style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _loading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _connectAndNavigate('doctor', '/doctor', name: 'Dr. Sarah Lee'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: Color(0xFF2A4D9B),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continue as Doctor'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => _connectAndNavigate('patient', '/patient', name: 'Patient'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: Color(0xFF2A4D9B),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            side: const BorderSide(color: Color(0xFF2A4D9B), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Continue as Patient'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
