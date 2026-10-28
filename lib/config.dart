import "dart:io";

class Config {
  static final port = int.parse(Platform.environment["PORT"] ?? "8080");
  static final dev = bool.parse(Platform.environment["DEV"] ?? "false");
}
