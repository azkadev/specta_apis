// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() async {
  // File file = File("/home/hexaminate/Documents/HEXAMINATE/app/specta/specta_paas/index");
  // Uint8List bytes = await file.readAsBytes();
  // print(bytes.length);
  // print(formatBytes(8192, 0));
  // print(formatBytes(bytes.length, 0));
  // List<List<int>> array = chunk(bytes, bytes.length ~/ 1000000);
  // for (var i = 0; i < array.length; i++) {
  //   List<int> loop_data = array[i];

  //   print(formatBytes(loop_data.length, 1));
  //   File save_file = File("/home/hexaminate/Documents/HEXAMINATE/app/specta/specta_bot_telegram/index");
  //   var getBytesNow = await save_file.readAsBytes();
  //   if (getBytesNow.length == bytes.length) {
  //     return print("out now");
  //   } else if (getBytesNow.length > bytes.length) {
  //     await save_file.delete();
  //     await save_file.writeAsBytes(
  //       loop_data,
  //       mode: FileMode.writeOnlyAppend,
  //     );
  //   } else {
  //     await save_file.writeAsBytes(
  //       loop_data,
  //       mode: FileMode.writeOnlyAppend,
  //     );
  //   }
  // }
  Duration();
  print(Size(megaByte: 1).toBytes());
  print(formatBytes(Size(yottaByte: 1000000, megaByte: 1, byte: 2, nibble: 4).toBytes(), 0));
}

class Size {
  final int yottaByte;
  final int zettaByte;
  final int exaByte;
  final int petaByte;
  final int terraByte;
  final int gigaByte;
  final int megaByte;
  final int kiloByte;
  final int byte;
  final int nibble;
  final int bit;
  Size({
    this.yottaByte = 0,
    this.zettaByte = 0,
    this.exaByte = 0,
    this.petaByte = 0,
    this.terraByte = 0,
    this.gigaByte = 0,
    this.megaByte = 0,
    this.kiloByte = 0,
    this.byte = 0,
    this.nibble = 0,
    this.bit = 0,
  });

  toBytes() {
    return int.parse("${yottaByte}${zettaByte}${exaByte}${petaByte}${terraByte}${gigaByte}${megaByte}${kiloByte}${byte}${nibble}${bit}");
  }
}

List<List<T>> chunk<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  int len = list.length;
  for (var i = 0; i < len; i += chunkSize) {
    int size = i + chunkSize;
    chunks.add(list.sublist(i, size > len ? len : size));
  }
  return chunks;
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
