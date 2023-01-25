import 'package:translator/translator.dart';

class Translation {
  static Future<String> translate(String words) async {
    final translator = GoogleTranslator();
    String translatedText = "";

    final translate = await translator.translate(words, from: 'en', to: 'tr');
    translatedText = translate.toString();
    return translatedText;
  }
}
