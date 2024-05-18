import 'package:flutter/material.dart';

class LoadingStateView extends StatelessWidget {
  const LoadingStateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            strokeAlign: 5,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
          ),
          const SizedBox(height: 30),
          Text(
            "Загрузка",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: "montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 20),
          )
        ],
      )
    );
  }
}
