import "dart:io";

import "package:http/http.dart";
import "package:test/test.dart";

void main() {
  final port = "8080";
  final host = "http://0.0.0.0:$port";
  late Process p;

  setUp(() async {
    p = await Process.start(
      "dart",
      ["run", "bin/server.dart"],
      environment: {"PORT": port, "DEV": "true"},
    );
    await _waitForServer(Uri.parse("$host/health"));
  });

  tearDown(() => p.kill());

  test("home page renders HTML", () async {
    final response = await get(Uri.parse("$host/"));
    expect(response.statusCode, 200);
    expect(response.headers["content-type"], contains("text/html"));
    expect(response.body, contains("Absurd Starter"));
  });

  test("health endpoint returns ok", () async {
    final response = await get(Uri.parse("$host/health"));
    expect(response.statusCode, 200);
    expect(response.body, "ok");
  });

  test("counter endpoint returns HTML fragment", () async {
    final response = await post(Uri.parse("$host/api/counter/increment"), body: {"count": "2"});
    expect(response.statusCode, 200);
    expect(response.headers["content-type"], contains("text/html"));
    expect(response.body, contains("Counter"));
    expect(response.body, contains("3"));
  });

  test("404", () async {
    final response = await get(Uri.parse("$host/foobar"));
    expect(response.statusCode, 404);
  });
}

Future<void> _waitForServer(Uri url) async {
  final timeoutAt = DateTime.now().add(const Duration(seconds: 10));

  while (DateTime.now().isBefore(timeoutAt)) {
    try {
      final response = await get(url);
      if (response.statusCode < 500) {
        return;
      }
    } catch (_) {}

    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  throw StateError("Server did not start in time.");
}
