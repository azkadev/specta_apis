// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, empty_catches, constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfred/alfred.dart';
import 'package:path/path.dart' as p;
import 'package:alfred/src/type_handlers/websocket_type_handler.dart';
import 'package:uuid/uuid.dart';

void main(List<String> arguments) async {
  var uuid = Uuid();

  String current_path = Directory.current.path;
  Alfred app = Alfred();
  int port = int.parse(Platform.environment["PORT"] ?? "8080");
  String host = Platform.environment["HOST"] ?? "0.0.0.0";

  /// state data ram websocket
  List<SocketClient> apps = [];
  List<SocketClient> computes = [];
  List<SocketClient> telegram_bots = [];
  List<SocketClient> telegram_userbots = [];

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

  app.get('/app', (req, res) {
    return WebSocketSession(
      onOpen: (ws) {
        bool is_save_socket = apps.saveSocketClient(
          webSocket: ws,
          socketClienType: SocketClienType.app,
        );
        if (is_save_socket) {
          ws.sendJson(({
            "@type": "connected",
          }));
        } else {
          ws.close();
        }
      },
      onClose: (ws) {
        apps.removeSocketClient(webSocket: ws);
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
        ws.sendJson(({"@type": "compute"}));
      },
    );
  });

  // WebSocket chat relay implementation
  app.get('/compute', (req, res) {
    return WebSocketSession(
      onOpen: (ws) {
        bool is_save_socket = computes.saveSocketClient(
          webSocket: ws,
          socketClienType: SocketClienType.compute,
        );
        if (is_save_socket) {
          ws.sendJson(({
            "@type": "connected",
          }));
        } else {
          ws.close();
        }
      },
      onClose: (ws) {
        computes.removeSocketClient(webSocket: ws);
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
        ws.sendJson(({"@type": "compute"}));
      },
    );
  });

  app.get('/telegram_bot', (req, res) {
    return WebSocketSession(
      onOpen: (ws) {
        bool is_save_socket = telegram_bots.saveSocketClient(
          webSocket: ws,
          socketClienType: SocketClienType.telegram_bot,
        );
        if (is_save_socket) {
          ws.sendJson(({
            "@type": "connected",
          }));
        } else {
          ws.close();
        }
      },
      onClose: (ws) {
        telegram_bots.removeSocketClient(webSocket: ws);
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
        ws.sendJson(({"@type": "compute"}));
      },
    );
  });
  app.get('/telegram_userbot', (req, res) {
    return WebSocketSession(
      onOpen: (ws) {
        bool is_save_socket = telegram_bots.saveSocketClient(
          webSocket: ws,
          socketClienType: SocketClienType.telegram_userbot,
        );
        if (is_save_socket) {
          ws.sendJson(({
            "@type": "connected",
          }));
        } else {
          ws.close();
        }
      },
      onClose: (ws) {
        telegram_userbots.removeSocketClient(webSocket: ws);
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
        ws.sendJson(({"@type": "compute"}));
      },
    );
  });

  await app.listen(port, host);
}

extension WebSocketExts on WebSocket {
  void sendJson(Map value) {
    send(json.encode(value));
  }
}

extension WebSocketClientDataExtension on List<SocketClient> {
  bool removeSocketClient({
    required WebSocket webSocket,
    bool withClose = false,
  }) {
    try {
      for (var i = 0; i < length; i++) {
        SocketClient socketClient = this[i];
        if (socketClient.webSocket == webSocket) {
          try {
            webSocket.close();
          } catch (e) {}
          removeAt(i);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool saveSocketClient({
    required WebSocket webSocket,
    required SocketClienType socketClienType,
  }) {
    try {
      List<String> socket_ids = map((e) => e.id).toList().cast<String>();
      late String new_socket_id = Uuid().v4();

      while (true) {
        if (!socket_ids.contains(new_socket_id)) {
          add(
            SocketClient(id: new_socket_id, socketClienType: socketClienType, webSocket: webSocket),
          );
          return true;
        } else {
          new_socket_id = Uuid().v4();
        }
      }
    } catch (e) {
      return false;
    }
  }
}

enum SocketClienType {
  app,
  compute,
  telegram_bot,
  telegram_userbot,
}

class SocketClient {
  late String id;
  late SocketClienType socketClienType;
  late WebSocket webSocket;
  SocketClient({
    required this.id,
    required this.socketClienType,
    required this.webSocket,
  });

  Map toJson() {
    return {
      "@type": "socket",
      "socket_client_type": socketClienType,
      "web_socket": webSocket,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
