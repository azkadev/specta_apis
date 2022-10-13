// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:path/path.dart' as p;
import 'package:alfred/src/type_handlers/websocket_type_handler.dart';

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

  var users = <WebSocket>[];

  // WebSocket chat relay implementation
  app.get('/ws', (req, res) {
    return WebSocketSession(
      onOpen: (ws) {
        ws.sendJson(({"@type": "connected"}));
        users.add(ws);
        users.where((user) => user != ws).forEach((user) => user.send('A new user joined the chat.'));
      },
      onClose: (ws) {
        users.remove(ws);
        users.forEach((user) => user.send('A user has left.'));
      },
      onMessage: (ws, dynamic data) async {
        if (data is String == false) {
          return ws.sendJson(({"@type": "error", "error_code": "data_must_be_json"}));
        }
        late Map jsonData = {};
        try {
          jsonData = json.decode(data);
        } catch (e) {}

        if (jsonData.isEmpty) {
          return ws.sendJson(({"@type": "error", "error_code": "data_must_be_not_empty"}));
        }
        late String method = "";

        try {
          method = jsonData["@type"];
        } catch (e) {}

        if (method.isEmpty) {
          return ws.sendJson(({
            "@type": "error",
            "error_code": "method_must_be_not_empty",
          }));
        }
        ws.sendJson(({"@type": "server"}));
        users.forEach((user) => user.send(data));
      },
    );
  });
  //await run
  await app.listen(port, host);
}

extension WebSocketExts on WebSocket {
  void sendJson(Map value) {
    send(json.encode(value));
  }
}
