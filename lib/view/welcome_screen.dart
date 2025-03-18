import 'package:a1/view/sign_in_screen.dart';
import 'package:a1/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String routeName="Welcome screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb51837), Color(0xff661c3a), Color(0xff301939)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          spacing: 20.h,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "Welcome Back",
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w700,
                fontSize: 26.r,
              ),
            ),
            SizedBox(height: 30.h,),
            OutlinedButton(
              onPressed: () => {
                Navigator.pushNamed(context, SignInScreen.routeName)
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide(color: const Color.fromARGB(240, 255, 255, 255), width: 2),
                padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 8.h),
              ),
              child: Text(
                "SIGN IN",
                style: TextStyle(fontSize: 22.r, color: Colors.white),
                
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.pushNamed(context, SignUpView.routeName)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(241, 255, 255, 255),
                // minimumSize: Size(200.w, 50.h),
                padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 8.h),
              ),
              child: Text(
                "SIGN UP",
                style: TextStyle(fontSize: 22.r, color: Color(0xff301939),
              ),
            )
        )],
        ),
      ),
    );
  }
}
