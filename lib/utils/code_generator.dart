import 'dart:math';

class CodeGenerator {
  String generateCode() {
    final random = Random();

    int code = random.nextInt(10000);

    String formattedCode = code.toString().padLeft(4, '0');

    return formattedCode;
  }
}
