// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:sherlog/sherlog.dart';

void main() {
  final sherlog = Sherlog(lineLength: 100);
  sherlog.info(
    headers: ['Header A', 'Header B'],
    {
      'num': 1,
      'bool': true,
      'string': 'Small and easy to use and extensible logger which prints beautiful logs.',
      'string key of a long ass variant': 'Small and easy to use and extensible logger which prints beautiful logs. x',
      'list': ['1', 2],
      'map':{
        'map':{
          'map':{
            'string key of a long ass variant':'Small and easy to use and extensible logger which prints beautiful logs. x Small and easy to use and extensible logger which prints beautiful logs. x'
          }
        }
      }
    },
  );
}
