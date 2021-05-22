import 'package:firebase_core/firebase_core.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/landing_page',
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
            primaryColor: AppColors.purple, canvasColor: Colors.transparent),
      ),
    );
  }
}
