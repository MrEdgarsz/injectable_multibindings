import 'package:injectable_multibindings/injectable_multibindings.dart';

abstract class Writer {
  void write();
}

abstract class Reader {
  void read();
}

@MultiBinding()
class FileIO implements Writer, Reader {
  @override
  void write() {}

  @override
  void read() {}
}

@MultiBinding()
class ConsoleIO implements Writer {
  @override
  void write() {}
}
