import "dart:async";
import "dart:convert";
import "dart:io";

import "package:absurd_starter/config.dart";
import "package:absurd_starter/router.dart";
import "package:hotreloader/hotreloader.dart";
import "package:relic/relic.dart";

Future<void> main() async {
  final runtime = await createRuntime();

  if (Config.dev) {
    await enableHotReload(runtime);
  }

  stdout.writeln("Server started on ${runtime.server.port}");

  final signals = [
    ProcessSignal.sigint,
    if (!Platform.isWindows) ProcessSignal.sigterm,
  ];

  for (final signal in signals) {
    signal.watch().listen((_) {
      unawaited(shutdown(runtime));
    });
  }
}

Future<ServerRuntime> createRuntime() async {
  final app = RelicApp();

  final runtime = ServerRuntime(app);

  if (Config.dev) {
    app.get("/__dev/reload", (request) {
      return Hijack((channel) {
        unawaited(runtime.liveReload.addClient(channel.sink, channel.stream));
      });
    });
  }

  router(app);

  runtime.server = await app.serve(address: InternetAddress.anyIPv4, port: Config.port);
  return runtime;
}

Future<void> enableHotReload(ServerRuntime runtime) async {
  try {
    await HotReloader.create(
      onAfterReload: (_) {
        runtime.liveReload.reloadBrowsers();
        stdout.writeln("[Server hot reloaded]");
      },
    );
  } on StateError catch (e) {
    if (e.message.contains("VM service not available")) {
      stdout.writeln("Hot reload not available");
    } else {
      rethrow;
    }
  }
}

Future<void> shutdown(ServerRuntime runtime) async {
  stdout.writeln("Shutting down...");
  await runtime.close(force: false);
  exit(0);
}

class ServerRuntime {
  ServerRuntime(this.app);

  final RelicApp app;
  late final RelicServer server;

  final liveReload = DevBrowserReloader();

  Future<void> close({required bool force}) async {
    await liveReload.close();
    await app.close();
  }
}

class DevBrowserReloader {
  final _clients = <StreamSink<List<int>>>{};

  Future<void> addClient(StreamSink<List<int>> sink, Stream<List<int>> stream) async {
    sink.add(
      utf8.encode(
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/event-stream; charset=utf-8\r\n"
        "Cache-Control: no-cache\r\n"
        "Connection: keep-alive\r\n"
        "\r\n"
        "retry: 500\n\n",
      ),
    );

    _clients.add(sink);

    await stream.drain<void>();
    _clients.remove(sink);
  }

  void reloadBrowsers() {
    for (final client in List<StreamSink<List<int>>>.from(_clients)) {
      try {
        client.add(utf8.encode("data: reload\n\n"));
      } catch (_) {
        _clients.remove(client);
      }
    }
  }

  Future<void> close() async {
    for (final client in List<StreamSink<List<int>>>.from(_clients)) {
      await client.close();
    }
    _clients.clear();
  }
}
