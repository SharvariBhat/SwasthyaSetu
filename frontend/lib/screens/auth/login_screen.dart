import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("SwasthyaSetu Login"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {

                print("Login pressed");

              },
              child: Text("Login"),
            )

          ],
        ),
      ),
    );
  }
}