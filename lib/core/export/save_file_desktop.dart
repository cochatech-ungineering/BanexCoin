import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<void> saveFile(String filename, Uint8List bytes) async {
  final dir = await _getDownloadDir();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
}

Future<Directory> _getDownloadDir() async {
  // Android: use public Downloads folder so user can see the file
  if (Platform.isAndroid) {
    final dir = Directory('/storage/emulated/0/Download');
    if (await dir.exists()) return dir;
  }

  // Desktop (Windows/macOS/Linux): use system Downloads
  try {
    final dir = await getDownloadsDirectory();
    if (dir != null) return dir;
  } catch (_) {}

  // Fallback
  return await getApplicationDocumentsDirectory();
}
