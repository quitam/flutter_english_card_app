import 'dart:math';

import 'package:learn_english_app/packages/quote/quote_model.dart';
import 'package:learn_english_app/packages/quote/quotes.dart';

class Quotes {
  static final Quotes _instance = Quotes._internal();
  static List<Quote> datas = [];
  Quotes._internal();

  factory Quotes() => _instance;
  getAll() {
    // datas = await compute(convert, allquotes);
    datas = allquotes.map((e) => Quote.fromJson(e)).toList();
  }

  static List<Quote> convert(List<dynamic> quotes) {
    return quotes.map((e) => Quote.fromJson(e)).toList();
  }

  Quote? getByWord(String word) {
    List<Quote> quotes = datas.where((element) {
      String content = element.getContent() ?? " ";
      return content.contains(word);
    }).toList();
    Random ran = Random();
    return quotes.isEmpty ? null : quotes[ran.nextInt(quotes.length)];
  }

  int _getRandomIndex() {
    return Random.secure().nextInt(allquotes.length);
  }

  Quote getRandom() {
    return datas[_getRandomIndex()];
  }
}
