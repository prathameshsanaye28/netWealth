import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/firebase_options.dart';
import 'package:netwealth_vjti/models/populate_users.dart';
import 'package:netwealth_vjti/resources/job_matching_provider.dart';
import 'package:netwealth_vjti/resources/matching_provider.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/api_marketplace.dart';
import 'package:netwealth_vjti/screens/auth_screens/login.dart';
import 'package:netwealth_vjti/screens/mainlayout_screen.dart';
import 'package:netwealth_vjti/screens/networking_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userProvider = UserProvider();
  await userProvider.initialize();
  //populateFintechJobs();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: userProvider),
    ],
    child: MyApp()),
);
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
   MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: userProvider),
        // ChangeNotifierProvider(
        //   create: (_) => UserProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => MatchingProvider(UserProvider()), // Pass UserProvider instance here
        // ),
        ChangeNotifierProvider(
          create: (_) => ApiProvider(), // Pass UserProvider instance here
        ),
        // ChangeNotifierProvider(
        //   create: (_) => , // Pass UserProvider instance here
        // ),
        ChangeNotifierProxyProvider<UserProvider, JobMatchingProvider>(
          create: (context) => JobMatchingProvider(context.read<UserProvider>()),
          update: (context, userProvider, previousJobMatchingProvider) =>
              previousJobMatchingProvider ?? JobMatchingProvider(userProvider),
        ),
         ChangeNotifierProxyProvider<UserProvider, MatchingProvider>(
      create: (context) => MatchingProvider(context.read<UserProvider>()),
      update: (context, userProvider, matchingProvider) => 
        matchingProvider ?? MatchingProvider(userProvider),
    ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: auth.currentUser == null?LoginScreen():MainLayoutScreen(),
      ),
    );
  }
}


