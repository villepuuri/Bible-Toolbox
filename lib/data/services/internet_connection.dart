import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnection {
  ///
  /// Checks if the phone is connected to the internet.
  ///
  /// Returns true if connection works as expected.
  ///
  /// Throws:
  /// - [TimeoutException] if slow internet
  static Future<bool> get isConnected async {
    // Check the network status
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    // An actual internet test
    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on TimeoutException {
      debugPrint('Timeout occurred while checking the internet connection');
      return false;
    } catch (_) {
      return false;
    }
  }
}
