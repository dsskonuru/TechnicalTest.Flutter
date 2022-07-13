import 'package:flutter/widgets.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:lottie/lottie.dart';

Widget handleErrorUI(Object err, StackTrace? st) {
  debugPrint(err.toString());
  List<Widget> errorWidgets = [];
  if (err is NoConnectionFailure) {
    errorWidgets = [
      Lottie.asset(
        'assets/animations/no-connection.json',
        height: 200,
        width: 200,
      ),
      const Text(
        "No connection, but you can still access bookmarked posts",
      ),
    ];
  } else {
    errorWidgets = [
      Lottie.asset(
        'assets/animations/error.json',
        height: 200,
        width: 200,
      ),
      const Text(
        "Something went wrong, please try again later",
      ),
    ];
  }
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: errorWidgets,
    ),
  );
}
