// ignore_for_file: depend_on_referenced_packages

import "dart:io";

import "package:http/http.dart" as http;

const _packageName = "basecoat-css";
const _version = "1.0.2";
const _outputDir = "basecoat";
const _jsOutputPath = "public/basecoat.all.min.js";
const _jsBundle = "js/all.min.js";

const _bundles = <String>[
  "basecoat.cdn.min.css",
  "basecoat-vega.cdn.min.css",
  "basecoat-nova.cdn.min.css",
  "basecoat-maia.cdn.min.css",
  "basecoat-lyra.cdn.min.css",
  "basecoat-mira.cdn.min.css",
  "basecoat-luma.cdn.min.css",
  "basecoat-sera.cdn.min.css",
  "basecoat-rhea.cdn.min.css",
  "basecoat-base.cdn.min.css",
  "basecoat-compat.cdn.min.css",
];

Future<void> main() async {
  stdout.writeln("Downloading Basecoat CSS $_version...");

  final outputDir = Directory(_outputDir);
  await outputDir.create(recursive: true);

  for (final fileName in _bundles) {
    final url = Uri.https("cdn.jsdelivr.net", "/npm/$_packageName@$_version/dist/$fileName");
    final response = await http.get(url);

    if (response.statusCode != HttpStatus.ok) {
      stderr.writeln("Failed to download $fileName from $url: HTTP ${response.statusCode}");
      exitCode = 1;
      return;
    }

    final outputFile = File("$_outputDir/$fileName");
    await outputFile.writeAsBytes(response.bodyBytes);
    stdout.writeln("Wrote ${outputFile.path}");
  }

  final jsUrl = Uri.https("cdn.jsdelivr.net", "/npm/$_packageName@$_version/dist/$_jsBundle");
  final jsResponse = await http.get(jsUrl);

  if (jsResponse.statusCode != HttpStatus.ok) {
    stderr.writeln("Failed to download $_jsBundle from $jsUrl: HTTP ${jsResponse.statusCode}");
    exitCode = 1;
    return;
  }

  final jsOutputFile = File(_jsOutputPath);
  await jsOutputFile.parent.create(recursive: true);
  await jsOutputFile.writeAsBytes(jsResponse.bodyBytes);
  stdout.writeln("Wrote ${jsOutputFile.path}");
}
