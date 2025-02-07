import 'package:logger/logger.dart';

enum LogLevel {
  all(Level.all),
  trace(Level.trace),
  debug(Level.debug),
  info(Level.info),
  warning(Level.warning),
  error(Level.error),
  fatal(Level.fatal),
  off(Level.off);

  const LogLevel(this.loggerLevel);

  final Level loggerLevel;
}
