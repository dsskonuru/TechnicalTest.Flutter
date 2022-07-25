
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoCommentsWidget extends StatelessWidget {
  const NoCommentsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/no-bookmarks.json',
            height: 200,
            width: 200,
          ),
          const Text(
            "No comments available",
          ),
        ],
      ),
    );
  }
}
