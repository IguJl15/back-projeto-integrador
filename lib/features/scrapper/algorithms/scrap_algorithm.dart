import '../models/news.dart';

abstract interface class ScrapAlgorithm {
  Future<List<News>> scrap();
}
