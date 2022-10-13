// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  String current_path = Directory.current.path;
  Alfred app = Alfred();
  int port = int.parse(Platform.environment["PORT"] ?? "8080");
  String host = Platform.environment["HOST"] ?? "0.0.0.0";
  app.get('/*', (req, res) {
    try {
      return Directory('web/');
    } catch (e) {}
  });
  app.all("/", (req, res) {
    try {
      res.headers.contentType = ContentType.html;
      return File(p.join(current_path, "web", "index.html"));
    } catch (e) {
      return res.json({"@type": "ok"});
    }
  });

  //await run
  await app.listen(port, host);
}
