import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/views/home_view.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  String _selectedRole = Roles.doctor; // Default selected role is Doctor
  String _username = ''; // Initially empty username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: [Roles.doctor, Roles.patient]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await ApiService.login(
                  role: _selectedRole,
                  username: _username,
                );

                if (response is Map && response.containsKey('error')) {
                  Future.delayed(Duration.zero, () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          errorTitle: 'Error',
                          errorMessage: response['message'][0],
                          onOkPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        );
                      },
                    );
                  });
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  final String? token = response['_id'];
                  final String? role = response['role'];

                  if (token != null) {
                    await prefs.setString('token', token);
                  }

                  if (role != null) {
                    await prefs.setString('role', role);
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeViewWrapper(
                        selectedRole: role,
                        token: token,
                      ),
                    ),
                    ModalRoute.withName('/'), // Route to remove until
                  );
                }
              },
              child: Text('Join as $_selectedRole'),
            ),
          ],
        ),
      ),
    );
  }
}
