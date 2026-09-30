import "dart:async";
import "dart:io";

import "package:absurd_starter/config.dart";
import "package:absurd_starter/router.dart";
import "package:relic/relic.dart";

Future<void> main() async {
  final runtime = await createRuntime();

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

  router(app);

  runtime.server = await app.serve(address: InternetAddress.anyIPv4, port: Config.port);
  return runtime;
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

  Future<void> close({required bool force}) async {
    await app.close();
  }
}
