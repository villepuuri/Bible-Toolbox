import 'package:bible_toolbox/core/helpers/shared_preferences_keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/helpers/language_helper.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  Future<void> _getAsyncInfo(BuildContext context) async {
    /*
    * This function checks all the asynchronous info required in the loading page
    * */
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if this is the first time opening the app
    // if (prefs.getBool(SharedPreferencesKeys.firstTimeOpened) ?? false) {
    if (true) { // todo: Change this to the real one
      debugPrint('- It is the first time opening the app -> to Welcome Screen');
      await prefs.setBool(SharedPreferencesKeys.firstTimeOpened, false);
      // Open the language selector
      UnimplementedError();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } else {
      // Not the first time, open the home page
      debugPrint('- It not the first time using the app -> to Home Screen');
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('\n*** In loading screen ***');

    // Check if this is the first time the app is opened
    _getAsyncInfo(context);
    return const Scaffold();
  }
}
