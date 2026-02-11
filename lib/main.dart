import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/core/constants/colors.dart';
import 'package:pinterest/core/navigation/app_router.dart';
import 'package:pinterest/data/local/saved_pin_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest/data/local/board_model.dart';
import 'package:clerk_flutter/clerk_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await dotenv.load(fileName: ".env");
 
  await Hive.initFlutter();

  Hive.registerAdapter(BoardModelAdapter());
  Hive.registerAdapter(SavedPinModelAdapter());

  await Hive.openBox<BoardModel>('boardsBox');
  await Hive.openBox<SavedPinModel>('pinsBox');


    runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY']!,
      ),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: createRouter(context),
      title: 'Pinterest Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.black,
      ),
    );
  }
}