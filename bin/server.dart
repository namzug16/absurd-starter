import "dart:async";
import "dart:io";

import "package:absurd_starter/config.dart";
import "package:absurd_starter/router.dart";
import "package:hotreloader/hotreloader.dart";
import "package:netto/netto.dart";

Future<void> main() async {
  final runtime = Config.dev
      ? await withHotReload(
          (runtime) => createServer(liveReload: runtime.liveReload),
        )
      : ServerRuntime(await createServer());

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

Future<HttpServer> createServer({
  DevBrowserReloader? liveReload,
}) async {
  final app = Netto();

  if (Config.dev && liveReload != null) {
    app.get("/__dev/reload", (ctx) {
      ctx.request.hijack((request) {
        unawaited(liveReload.addClient(request.response));
      });
    });
  }

  router(app);

  return app.serve(InternetAddress.anyIPv4, Config.port);
}

Future<ServerRuntime> withHotReload(
  FutureOr<HttpServer> Function(ServerRuntime runtime) serverFactory,
) async {
  final runtime = ServerRuntime();

  Future<void> obtainNewServer() async {
    final willReplaceServer = runtime.current != null;

    if (willReplaceServer) {
      runtime.liveReload.reloadBrowsers();
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    await runtime.replaceWith(() => serverFactory(runtime));

    if (willReplaceServer) {
      stdout.writeln("[Server hot reloaded]");
    }
  }

  try {
    await HotReloader.create(
      onAfterReload: (_) {
        unawaited(obtainNewServer());
      },
    );
  } on StateError catch (e) {
    if (e.message.contains("VM service not available")) {
      stdout.writeln("Hot reload not available");
    } else {
      rethrow;
    }
  }

  await obtainNewServer();
  stdout.writeln("Server started on ${runtime.current?.port}");

  return runtime;
}

Future<void> shutdown(ServerRuntime runtime) async {
  stdout.writeln("Shutting down...");
  await runtime.close(force: false);
  exit(0);
}

class ServerRuntime {
  ServerRuntime([this.current]);

  HttpServer? current;

  final liveReload = DevBrowserReloader();

  Future<void> replaceWith(FutureOr<HttpServer> Function() serverFactory) async {
    await current?.close(force: true);
    current = await serverFactory();
  }

  Future<void> close({required bool force}) async {
    await liveReload.close();
    await current?.close(force: force);
  }
}

class DevBrowserReloader {
  final _clients = <IOSink>{};

  Future<void> addClient(HttpResponse response) async {
    response.bufferOutput = false;
    response.headers
      ..contentType = ContentType("text", "event-stream", charset: "utf-8")
      ..set(HttpHeaders.cacheControlHeader, "no-cache")
      ..set(HttpHeaders.connectionHeader, "keep-alive");

    response.write("retry: 500\n\n");
    await response.flush();

    _clients.add(response);

    response.done.whenComplete(() {
      _clients.remove(response);
    });
  }

  void reloadBrowsers() {
    for (final client in List<IOSink>.from(_clients)) {
      try {
        client.write("data: reload\n\n");
        if (client is HttpResponse) {
          unawaited(client.flush());
        }
      } catch (_) {
        _clients.remove(client);
      }
    }
  }

  Future<void> close() async {
    for (final client in List<IOSink>.from(_clients)) {
      await client.close();
    }
    _clients.clear();
  }
}
