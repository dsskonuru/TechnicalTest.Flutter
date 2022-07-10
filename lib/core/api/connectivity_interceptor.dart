import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    debugPrint("Conncectivity Check!!");
    final connectivityResult = await Connectivity().checkConnectivity();

    final isNotConnected = connectivityResult == ConnectivityResult.none;

    if (isNotConnected) {
      throw NotConnectedException();
    }

    return request;
  }
}

class NotConnectedException implements Exception {
  final message =
      "You are not connected to the internet. Please check your connection and try again.";
  @override
  String toString() => message;
}
