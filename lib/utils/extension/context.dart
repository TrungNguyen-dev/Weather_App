import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get tt => Theme.of(this).textTheme;
  MediaQueryData get mq => MediaQuery.of(this);
  double get sWidth => mq.size.width;
  double get sHeight => mq.size.height;
  EdgeInsets get sPadding => mq.padding;
}
