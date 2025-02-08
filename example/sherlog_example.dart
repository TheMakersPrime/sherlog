// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:sherlog/sherlog.dart';

void main() {
  final sherlog = Sherlog(
    level: LogLevel.all,
    lineLength: 100,
    levelColors: {
      LogLevel.trace: AnsiColor.fg(ConsoleColor.violet.code),
      LogLevel.fatal: AnsiColor.fg(ConsoleColor.purple.code),
    },
  );

  sherlog.trace('Info');
  sherlog.fatal('Info');
}
