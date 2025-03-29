// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openUnityApp();
    });
  }

  void _openUnityApp() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.perrytheboss.pineapple',
      componentName: 'com.unity3d.player.UnityPlayerActivity',
    );

    try {
      await intent.launch();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(204, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Redirecting to Unity...', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
