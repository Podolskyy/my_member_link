import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_member_link/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds before navigating to the login screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212), // Dark background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minimalistic and modern text design with a dark theme
            Text(
              "MyMemberLink",
              style: TextStyle(
                fontSize: 40, // Larger font size for emphasis
                fontWeight: FontWeight.bold,
                color: Colors
                    .white, // White text color to contrast with dark background
                letterSpacing: 2, // Slight letter spacing for a sleek look
              ),
            ),
            SizedBox(
                height: 30), // Add space between text and progress indicator
            // CircularProgressIndicator with custom styling for an interesting design
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepPurple), // Customize color
                strokeWidth: 4, // Adjust the stroke width for a sleek look
              ),
            ),
          ],
        ),
      ),
    );
  }
}
