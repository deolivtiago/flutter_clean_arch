import 'package:flutter/material.dart';

showErrorMessage(BuildContext context, error) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[900],
      content: Text(
        error,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
