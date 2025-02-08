// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:sherlog/sherlog.dart';

const _headerTopLeft = '╔╣';
const _topLeft = '╔';
const _bottomLeft = '╚';
const _vertical = '║';
const _verticalWithPoint = '╟';
const _shortVertical = '‖';
const _horizontal = '═';
const _topRight = '╗';
const _bottomRight = '╝';
const _padding = ' ';

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
    String? title,
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
      title: title,
    );
  }

  void _log(
    Level level,
    dynamic message, {
    List<Object> headers = const [],
    required bool includeSeparation,
    String? title,
    Object? detail,
    StackTrace? stackTrace,
  }) {
    final prettyMessage = _prettifyText(message);
    if (headers.isNotEmpty) {
      final headerOutput = headers.join(' $_shortVertical ');
      final header = '$_headerTopLeft $headerOutput $_shortVertical';
      _logger.log(level, '$header${_horizontal * (lineLength - header.length)}$_topRight');
    }

    if (headers.isEmpty && includeSeparation) {
      _logger.log(level, '$_topLeft${_horizontal * (lineLength - 1)}$_topRight');
    }
    if (title != null && title.isNotEmpty) {
      _logger.log(level, _addVerticalLines('$title:', isTitle: true));
    }
    _logger.log(level, prettyMessage);

    if (includeSeparation) {
      _logger.log(level, '$_bottomLeft${_horizontal * (lineLength - 1)}$_bottomRight');
    }
  }

  String _prettifyText(dynamic text) {
    final String pretty;

    if (text is List || text is Map) {
      pretty = JsonEncoder.withIndent(' ').convert(text);
    } else {
      pretty = text.toString();
    }

    final parts = pretty.split('\n');

    if (parts.length == 1) return _wrapText(pretty);

    final buffer = StringBuffer();

    for (final part in parts) {
      buffer.writeln(_wrapText(part));
    }

    return buffer.toString().trimRight();
  }

  String _wrapText(String text) {
    final parts = text.split(' ');
    final buffer = StringBuffer();
    final lineParts = <String>[];

    for (final part in parts) {
      final linePartLength = lineParts.join(' ').length;
      final partLength = part.length + 1;
      // Length of 2 vertical lines and 2 character on either sides
      final probableLineLength = linePartLength + partLength + 4;

      if (probableLineLength > lineLength) {
        buffer.writeln(_addVerticalLines(lineParts.join(' ')));
        lineParts.clear();
      }
      lineParts.add(part);
    }
    if (lineParts.isNotEmpty) {
      buffer.writeln(_addVerticalLines(lineParts.join(' ')));
      lineParts.clear();
    }
    return buffer.toString().trimRight();
  }

  String _addVerticalLines(String text, {bool isTitle = false}) {
    final leftPadding = isTitle ? '' : ' ';
    final leftVerticalLine = isTitle ? _verticalWithPoint : _vertical;
    return '$leftVerticalLine$leftPadding$text${_padding * (lineLength - text.length - (leftPadding.isEmpty ? 2 : 3))} $_vertical';
  }
}
