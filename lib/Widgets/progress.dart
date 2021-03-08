import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor : AlwaysStoppedAnimation(Colors.cyan),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.cyan),
    )
  );
}
