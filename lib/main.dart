import 'package:a1/stores/providers/store_provider.dart';
import 'package:a1/view/home_screen.dart';
import 'package:a1/view/profile_screen.dart';
import 'package:a1/view/sign_in_screen.dart';
import 'package:a1/view/sign_up_view.dart';
import 'package:a1/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StoreProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            WelcomeScreen.routeName: (context) => const WelcomeScreen(),
            SignInScreen.routeName: (context) => SignInScreen(),
            SignUpView.routeName: (context) => const SignUpView(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            // StoresList.routeName: (context) => StoresList(),
            HomeScreen.routeName: (context) => HomeScreen(),
          },
          initialRoute: WelcomeScreen.routeName,
          //home: StoresList(),
        );
      },

      child: const WelcomeScreen(),
    );
  }
}
