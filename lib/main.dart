import 'package:todo_firebase_app/screens/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_firebase_app/screens/auth_wrapper.dart';
import 'package:todo_firebase_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_option.dart';


import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );


  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perfume and Fragnance',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const AuthWrapper(),
    );

  }
}
