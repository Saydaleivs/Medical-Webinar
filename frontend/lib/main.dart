import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/services/notitfication_service.dart';
import 'package:flutter_application_1/views/home_view.dart';
import 'package:flutter_application_1/views/signin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve token & role from cookies
  String? token = await AuthService.getToken();
  String? role = await AuthService.getRole();

  await LocalNotifications.init();

  runApp(MaterialApp(
    home: token != null && role != null
        ? HomeViewWrapper(
            token: token,
            selectedRole: role,
          )
        : const SigninView(),
    routes: {
      '/signin/': (context) => const SigninView(),
    },
  ));
}
