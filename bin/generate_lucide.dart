// ignore_for_file: depend_on_referenced_packages

import "dart:convert";
import "dart:io";

import "package:archive/archive.dart";
import "package:http/http.dart" as http;

const _version = "1.33.0";
const _iconsUrl = "https://github.com/lucide-icons/lucide/releases/download/$_version/lucide-icons-$_version.zip";
const _outputPath = "lib/src/ui/lucide.dart";

typedef _Icon = (String name, String content);

Future<void> main() async {
  stdout.writeln("Downloading Lucide icons ($_version)...");

  final response = await http.get(Uri.parse(_iconsUrl));
  if (response.statusCode != HttpStatus.ok) {
    stderr.writeln("Failed to download icons zip: HTTP ${response.statusCode}");
    exitCode = 1;
    return;
  }

  final archive = ZipDecoder().decodeBytes(response.bodyBytes);
  final icons = <_Icon>[];

  for (final file in archive.files) {
    if (!file.isFile || !file.name.endsWith(".svg")) {
      continue;
    }

    final svg = utf8.decode(file.content, allowMalformed: true);
    final content = _extractSvgContent(svg);

    if (content == null || content.trim().isEmpty) {
      continue;
    }

    final baseName = file.name.split("/").last.replaceAll(".svg", "");
    final methodName = _toLowerCamelCase(baseName);

    if (methodName.isEmpty) {
      continue;
    }

    icons.add((methodName, content));
  }

  icons.sort((a, b) => a.$1.compareTo(b.$1));

  final outputFile = File(_outputPath);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(_buildOutput(icons));

  stdout.writeln("Generated $_outputPath with ${icons.length} icons");
}

String? _extractSvgContent(String svg) {
  final openStart = svg.indexOf("<svg");
  if (openStart == -1) {
    return null;
  }

  final openEnd = svg.indexOf(">", openStart);
  if (openEnd == -1) {
    return null;
  }

  final closeStart = svg.indexOf("</svg>", openEnd + 1);
  if (closeStart == -1) {
    return null;
  }

  return svg.substring(openEnd + 1, closeStart);
}

String _toLowerCamelCase(String value) {
  final parts = value.split("-").map((part) => part.replaceAll(RegExp(r"[^A-Za-z0-9]"), "")).where((part) => part.isNotEmpty).toList();

  if (parts.isEmpty) {
    return "";
  }

  final first = parts.first.toLowerCase();
  final rest = parts.skip(1).map((part) => "${part[0].toUpperCase()}${part.substring(1).toLowerCase()}");
  final joined = "$first${rest.join()}";

  if (RegExp(r"^[0-9]").hasMatch(joined)) {
    return "icon${joined[0].toUpperCase()}${joined.substring(1)}";
  }

  return joined;
}

String _buildOutput(List<_Icon> methods) {
  final buffer = StringBuffer()
    ..writeln("// GENERATED CODE - DO NOT MODIFY BY HAND")
    ..writeln("// dart format off")
    ..writeln("// ignore_for_file: type=lint")
    ..writeln()
    ..writeln("import 'package:htmleez/htmleez.dart';")
    ..writeln()
    ..writeln("class Lucide {")
    ..writeln("  static HTML _svg(List<HTML> extraContent, String paths) => svg([")
    ..writeln('        \$("xmlns")("http://www.w3.org/2000/svg"),')
    ..writeln('        \$("width")("24"),')
    ..writeln('        \$("height")("24"),')
    ..writeln('        \$("viewBox")("0 0 24 24"),')
    ..writeln('        \$("fill")("none"),')
    ..writeln('        \$("stroke")("currentColor"),')
    ..writeln('        \$("stroke-width")("2"),')
    ..writeln('        \$("stroke-linecap")("round"),')
    ..writeln('        \$("stroke-linejoin")("round"),')
    ..writeln("        ...extraContent,")
    ..writeln("        Raw(paths),")
    ..writeln("      ]);")
    ..writeln();

  for (final method in methods) {
    final content = jsonEncode(method.$2);
    buffer
      ..writeln("  static HTML ${method.$1}([List<HTML> extraContent = const []]) => _svg(extraContent, $content);")
      ..writeln();
  }

  buffer.writeln("}");
  return buffer.toString();
}
