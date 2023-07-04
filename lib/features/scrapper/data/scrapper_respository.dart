import '../../../core/utils/uu_aidi.dart';
import '../models/news.dart';

class ScrapperRepository {
  static List<News> list = [];

  List<News> getAllNews() {
    return list.map((e) => e.copyWith()).toList();
  }

  saveAll(List<News> news) {
    list.addAll(news.map((e) => e.copyWith(id: UuAidi().generateV4())));
  }
}
