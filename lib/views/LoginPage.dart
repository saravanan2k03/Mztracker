import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mztrackertodo/utils/Bottomnavbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                child: Lottie.asset('assets/lottie/loginpage.json'),
              ),
              const SizedBox(height: 50),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const BottomnavbarPage()),
                  );
                },
                icon: Image.asset('assets/logo/google.png', height: 32, width: 32),
                label: const Text('Continue'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
