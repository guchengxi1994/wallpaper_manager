import 'dart:io';
import 'package:file_type/match.dart' as m;

class DevUtils {
  static Directory get executableDir =>
      File(Platform.resolvedExecutable).parent;

  static m.Match match = m.Match();
}
