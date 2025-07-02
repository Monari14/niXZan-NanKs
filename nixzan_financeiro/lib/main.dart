import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transacao.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransacaoAdapter());

  await Hive.openBox<Transacao>('transacoes');
  await Hive.openBox('config'); // <- nova box para tema

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    final configBox = Hive.box('config');
    isDark = configBox.get('isDark', defaultValue: false);
  }

  void toggleTheme() {
    final configBox = Hive.box('config');
    setState(() {
      isDark = !isDark;
      configBox.put('isDark', isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'niXZan - NanKs',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 150, 143, 255),),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 150, 143, 255),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(
        isDark: isDark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}
