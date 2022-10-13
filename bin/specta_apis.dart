import 'dart:io';

import 'package:alfred/alfred.dart'; 
void main(List<String> arguments) async {
  Alfred app = Alfred();
  int port = int.parse(Platform.environment["PORT"] ?? "8080");
  String host = Platform.environment["HOST"] ?? "0.0.0.0";
  app.all("/", (req, res) {
    return res.json({
      "@type": "ok"
    });
  });
  await app.listen(port, host);
}
