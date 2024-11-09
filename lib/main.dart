import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tankyou/auth/auth.dart';
import 'package:tankyou/components/my_theme.dart';
import 'package:tankyou/services/tank_service.dart';
import 'package:tankyou/services/image_service.dart';
import 'package:tankyou/views/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageService()),
        ChangeNotifierProvider(create: (context) => TankService()),
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
      statusBarColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
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
