import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:remindits/model/package_model.dart';

class ScraperService {
  static List<PackageModel> run(String html) {
    try {
      final soup = BeautifulSoup(html);
      final item = soup.findAll('article', class_: 'list-content__item');
      List<PackageModel> packages = [];
      for (var item in item) {
        final title = item.find('h3', class_: 'media__title')?.text ?? '';
        final desc = item.find('div', class_: 'media__desc')?.text ?? '';
        final link = item.find('a', class_: 'media__link')?.text ?? '';
        PackageModel model = PackageModel(
          title: title,
          desc: desc,
          link: link
        );
        packages.add(model);
      }
      return packages;
    } catch (e) {
      print(e);
    }
    return [];
  }
}
