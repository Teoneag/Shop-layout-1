import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/utils/routes.dart';
import '/utils/consts.dart';
import 'screens/login_screen.dart';
import '/screens/loading_screen.dart';
import 'utils/dialogs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// TODO: Theme
// TODO: safearea

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // default
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      onGenerateRoute: generateLocalRoutes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasData) {
            return const MyHomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appName),
        actions: [
          Padding(
            // TODO: remove debug and this padding
            padding: const EdgeInsets.only(right: 30),
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'logout':
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const LogOutDialog();
                      },
                    );
                    break;
                  // default:
                  //   Navigator.of(context).pushNamed(value);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
