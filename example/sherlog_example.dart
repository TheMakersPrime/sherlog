// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:sherlog/sherlog.dart';

void main() {
  final sherlog = Sherlog(lineLength: 50);
  sherlog.info('Log body' * 10, headers: [
    'Header 1',
    'Header 2',
    'Header 2',
    'Header 2',
  ]);
  sherlog.info({
    '0': 'value',
    '1': 'value',
    '2': 'value',
    '3': 'value',
    '4': 'value',
    '5': 'value',
    '6': 'value',
    '7': 'value',
  });
}
