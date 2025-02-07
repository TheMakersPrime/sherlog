// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'dart:convert';

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
    final prettyMessage = _prettifyText(message);
    if (headers.isNotEmpty) {
      final headerOutput = headers.join(' $_shortVertical ');
      final header = '$_headerTopLeft $headerOutput $_shortVertical';
      _logger.log(level, '$header${_horizontal * (lineLength - header.length)}');
    }

    if (headers.isEmpty && includeSeparation) {
      _logger.log(level, '$_topLeft${_horizontal * (lineLength - 1)}');
    }
    // TODO (Ishwor) Break message to fit the line length
    _logger.log(level, '$_vertical $prettyMessage');

    if (includeSeparation) {
      _logger.log(level, '$_bottomLeft${_horizontal * (lineLength - 1)}');
    }
  }

  String _prettifyText(dynamic text) {
    final String pretty;

    if (text is List || text is Map) {
      pretty = JsonEncoder.withIndent('   ').convert(text);
    } else {
      pretty = text;
    }

    final parts = pretty.split('\n');

    if (parts.length == 1) return _wrapText(pretty);

    final buffer = StringBuffer();

    for (final (index, part) in parts.indexed) {
      if (index == parts.length - 1) {
        buffer.writeln('  ${_wrapText(part)}');
      } else {
        buffer.writeln(_wrapText(part));
      }
    }

    return buffer.toString().trimRight();
  }

  String _wrapText(String text) {
    return text;
  }
}
