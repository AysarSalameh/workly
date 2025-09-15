import 'dart:html' as html;

class LanguageStorage {
  static Future<String?> getLanguageCode() async {
    return html.window.localStorage['language_code'];
  }

  static Future<void> setLanguageCode(String code) async {
    html.window.localStorage['language_code'] = code;
  }
}
