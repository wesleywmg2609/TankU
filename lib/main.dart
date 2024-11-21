import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tanku/auth/auth.dart';
import 'package:tanku/services/task_service.dart';
import 'package:tanku/widgets/my_theme.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/services/image_service.dart';
import 'package:tanku/screens/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageService()),
        ChangeNotifierProvider(create: (context) => TankService()),
        ChangeNotifierProvider(create: (context) => TaskService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSystemUIColors();
  }

  @override
  void didChangePlatformBrightness() {
    _updateSystemUIColors();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _updateSystemUIColors() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: const Color(0xfff6f6f6),
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: const Color(0xffffffff),
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neumorphism App',
      themeMode: ThemeMode.system,
      theme: lightMode,
      darkTheme: darkMode,
      home: const SplashPage(),
    );
  }
}
