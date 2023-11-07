import 'package:app_emerson/screens/budget_list.screen.dart';
import 'package:app_emerson/screens/client_list.screen.dart';
import 'package:app_emerson/screens/service_list.screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  runApp(
    MaterialApp(
      routes: {
        '/': (context) => MyHomePage(),
        '/budgetList': (context) => BudgetList(
              screenSize: MediaQuery.of(context).size,
            ),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.fallback(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final List<NavigationDestination> itensAppBar = [
  const NavigationDestination(
    icon: Icon(Icons.assessment_rounded),
    label: "Orçamentos",
  ),
  const NavigationDestination(
    icon: Icon(Icons.car_repair),
    label: "Serviços",
  ),
  const NavigationDestination(
    icon: Icon(Icons.people),
    label: "Clientes",
  )
];

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final screen = MediaQuery.of(context).size;
    final screens = [
      BudgetList(
        screenSize: screen,
      ),
      ServiceList(
        screenSize: screen,
      ),
      ClientList(
        screenSize: screen,
      ),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: index,
        destinations: itensAppBar,
        onDestinationSelected: (index) => setState(() => this.index = index),
      ),
    );
  }
}
