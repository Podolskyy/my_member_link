import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/main_screen.dart';
import 'package:my_member_link/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  bool rememberme = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/login.png'),
              const SizedBox(height: 20),
              TextField(
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Email",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordcontroller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Your Password",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Remember me",
                      style: TextStyle(color: Colors.white)),
                  Checkbox(
                    value: rememberme,
                    onChanged: (bool? value) {
                      setState(() {
                        String email = emailcontroller.text;
                        String pass = passwordcontroller.text;
                        if (value!) {
                          if (email.isNotEmpty && pass.isNotEmpty) {
                            storeSharedPrefs(value, email, pass);
                          } else {
                            rememberme = false;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please enter your credentials"),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                        } else {
                          email = "";
                          pass = "";
                          storeSharedPrefs(value, email, pass);
                        }
                        rememberme = value;
                      });
                    },
                  ),
                ],
              ),
              MaterialButton(
                elevation: 0,
                onPressed: onLogin,
                minWidth: 400,
                height: 50,
                color: Colors.deepPurple[700],
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const RegisterScreen()),
                  );
                },
                child: const Text("Create new account?",
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*************  ✨ Codeium Command ⭐  *************/
/******  6d5aa5c0-0ffb-4cc3-b5f9-bf249131e5ba  *******/
  void onLogin() {
  String email = emailcontroller.text;
  String password = passwordcontroller.text;

  // Check if email or password is empty
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Please enter email and password"),
    ));
    return;
  }

  // Regular expression to check if the email has a basic valid structure (contains '@' and a valid domain)
  final RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  // Check if the email is in valid format
  if (!emailRegExp.hasMatch(email)) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Please enter a valid email address"),
    ));
    return;
  }

  // Check if the password is at least 6 characters long
  if (password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Password must be at least 6 characters long"),
    ));
    return;
  }
    http.post(Uri.parse("${MyConfig.servername}/memberlink/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Color(0xFF121212),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const MainScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", "");
      prefs.setString("password", "");
      prefs.setBool("rememberme", value);
      emailcontroller.text = "";
      passwordcontroller.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailcontroller.text = prefs.getString("email") ?? "";
    passwordcontroller.text = prefs.getString("password") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}
