import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mztrackertodo/MainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import '../api/google_signin_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  GoogleSignInAccount? _currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Lottie.asset("assets/lottie/loginpage.json"),
              ),
              const SizedBox(
                height: 50,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  signIn();
                },
                icon: Image.asset(
                  "assets/logo/google.png",
                  height: 32,
                  width: 32,
                ),
                label: const Text("Sign In With Google"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    GoogleSignInApi.logout();
    final user = await GoogleSignInApi.login();
    if (user == null) {
      if (kDebugMode) {
        print("Failed To Sign");
      }
    } else {
      if (kDebugMode) {
        print("user.email${user.email}");
      }

      box.write("Name", user.displayName!);
      // ignore: use_build_context_synchronously
      GoogleSignInApi.GetInitialData(user.email, context);
      // ignore: use_build_context_synchronously
    }
  }
}
