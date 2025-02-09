// Copyright (c) 2025 TheMakersPrime Authors. All rights reserved.

import 'dart:convert';

import 'package:sherlog/sherlog.dart';

class Sherlog {
  Sherlog({
    this.lineLength = 100,
    this.level = LogLevel.trace,
    Map<LogLevel, AnsiColor>? levelColors,
  }) : _logger = Logger(
          level: level.loggerLevel,
          printer: PrettyPrinter(
            methodCount: 0,
            noBoxingByDefault: true,
            lineLength: lineLength,
            printEmojis: false,
            levelColors: levelColors?.map((key, value) => MapEntry(key.loggerLevel, value)),
          ),
        );

  final int lineLength;
  final LogLevel level;

  final Logger _logger;

  void trace(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.trace,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void debug(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.debug,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void info(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.info,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void warning(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.warning,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void error(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.error,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void fatal(
    Object message, {
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
    bool showSource = false,
  }) {
    _log(
      Level.fatal,
      message,
      headers: headers,
      title: title,
      detail: detail,
      stackTrace: stackTrace,
      showSource: showSource,
    );
  }

  void _log(
    Level level,
    Object message, {
    required bool showSource,
    List<Object> headers = const [],
    String? title,
    Object? detail,
    StackTrace? stackTrace,
  }) {
    if (headers.isNotEmpty) _printHeader(level, headers);

    _printBody(
      level,
      message,
      topDivider: headers.isEmpty,
      title: title,
    );

    if (detail != null) {
      _printBody(level, detail, topDivider: false);
    }

    if (stackTrace != null) {
      _printBody(level, stackTrace, topDivider: false);
    }

    if (showSource) {
      final trace = StackTrace.current.toString();
      final traceParts = trace.split('\n');

      if (traceParts.length > 2) {
        _printBody(
          level,
          traceParts[2],
          topDivider: headers.isEmpty,
        );
      }
    }
  }

  void _printHeader(Level level, List<Object> headers) {
    final headerOutput = headers.join(' $_shortVertical ');
    final header = '$_headerTopLeft $headerOutput $_shortVertical';
    _logger.log(level, '$header${_horizontal * (lineLength - header.length)}$_topRight');
  }

  void _printBody(
    Level level,
    dynamic message, {
    required bool topDivider,
    String? title,
  }) {
    final prettyMessage = _prettifyText(message);

    if (topDivider) {
      _logger.log(level, '$_topLeft${_horizontal * (lineLength - 1)}$_topRight');
    }
    if (title != null && title.isNotEmpty) {
      _logger.log(level, _wrapLine('$title:', isTitle: true));
    }
    _logger.log(level, prettyMessage);
    _logger.log(level, '$_bottomLeft${_horizontal * (lineLength - 1)}$_bottomRight');
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
        final line = lineParts.join(' ');
        if (line.isNotEmpty) {
          buffer.writeln(_wrapLine(line));
          lineParts.clear();
        }
      }
      lineParts.add(part);
    }
    if (lineParts.isNotEmpty) {
      buffer.writeln(_wrapLine(lineParts.join(' ')));
      lineParts.clear();
    }
    return buffer.toString().trimRight();
  }

  String _wrapLine(String line, {bool isTitle = false}) {
    final limit = lineLength - 4;
    if (line.length < limit) return _addVerticalLines(line, isTitle: isTitle);

    final buffer = StringBuffer();
    for (int i = 0; i < line.length; i += limit) {
      final wrappedLine = line.substring(i, i + limit > line.length ? line.length : i + limit);
      buffer.writeln(_addVerticalLines(wrappedLine, isTitle: isTitle));
    }

    return buffer.toString().trim();
  }

  String _addVerticalLines(String text, {required bool isTitle}) {
    final leftPadding = isTitle ? '' : ' ';
    final leftVerticalLine = isTitle ? _verticalWithPoint : _vertical;
    return '$leftVerticalLine$leftPadding$text${_padding * (lineLength - text.length - (leftPadding.isEmpty ? 2 : 3))} $_vertical';
  }
}

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
