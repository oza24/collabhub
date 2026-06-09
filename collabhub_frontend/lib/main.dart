import 'package:collabhub/core/network/dio_client.dart';

import 'package:collabhub/routes/app_router.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/socket/socket_service.dart';
import 'core/theme/app_theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await DioClient.initialize();
  SocketService.connect();
  runApp(

    const ProviderScope(

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(

      title: 'CollabHub',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      routerConfig: appRouter,
    );
  }
}