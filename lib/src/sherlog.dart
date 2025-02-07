// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'package:logger/logger.dart';
import 'package:sherlog/sherlog.dart';

const _headerTopLeft = '╔╣';
const _topLeft = '╔';
const _bottomLeft = '╚';
const _vertical = '║';
const _shortVertical = '‖';
const _horizontal = '═';

class Sherlog {
  Sherlog({
    this.lineLength = 100,
    this.level = LogLevel.trace,
  }) : _logger = Logger(
          level: level.loggerLevel,
          printer: PrettyPrinter(
            methodCount: 0,
            noBoxingByDefault: true,
            lineLength: lineLength,
            printEmojis: false,
          ),
        );

  final int lineLength;
  final LogLevel level;

  final Logger _logger;

  void info(
    Object message, {
    List<Object> headers = const [],
    bool includeSeparation = true,
    Object? detail,
    StackTrace? stackTrace,
  }) {
    _log(
      Level.info,
      message,
      headers: headers,
      detail: detail,
      stackTrace: stackTrace,
      includeSeparation: includeSeparation,
    );
  }

  void _log(
    Level level,
    dynamic message, {
    List<Object> headers = const [],
    required bool includeSeparation,
    Object? detail,
    StackTrace? stackTrace,
  }) {
    if (headers.isNotEmpty) {
      final headerOutput = headers.join(' $_shortVertical ');
      final header = '$_headerTopLeft $headerOutput $_shortVertical';
      _logger.log(level, '$header${_horizontal * (lineLength - header.length)}');
    }

    if (headers.isEmpty && includeSeparation) {
      _logger.log(level, '$_topLeft${_horizontal * (lineLength - 1)}');
    }
    // TODO (Ishwor) Break message to fit the line length
    _logger.log(level, '$_vertical $message');

    if (includeSeparation) {
      _logger.log(level, '$_bottomLeft${_horizontal * (lineLength - 1)}');
    }
  }
}
