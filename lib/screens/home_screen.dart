import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jamendo_music_player/theme/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size mq = MediaQuery.of(context).size;
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jamendo Player'),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(
            mq.width * 0.01,
            mq.height * 0.008,
            0,
            mq.height * 0.004,
          ),
          child: Image.asset('assets/icon/app_icon.png'),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeProvider.notifier).themeChanger(),
            tooltip: 'theme mode',
            icon: Icon(themeState.themeIcon),
          ),
        ],
      ),
      body: const Center(child: Text('Jamendo Music Player')),
    );
  }
}
