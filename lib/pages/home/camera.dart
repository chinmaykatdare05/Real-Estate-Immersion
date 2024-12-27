import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Camera')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Coming Soon!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('Tap the button below for Amazing visualizations'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set the text color to white
              ),
              onPressed: () {
                // Future functionality: Capture image
              },
              child: const Text('Open ARVR Camera'),
            ),

            // Uncomment if you want to show a loading indicator
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
