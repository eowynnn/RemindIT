import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:remindits/model/package_model.dart';

class ScraperService {
  static List<PackageModel> run(String html) {
    try {
      final soup = BeautifulSoup(html);
      final item = soup.findAll('div', class_: 'package-item');
      List<PackageModel> packages = [];
      for (var item in item) {
        final title = item.find('h3', class_: 'package-title')?.text ?? '';
        final desc = item.find('p', class_: 'package-description')?.text ?? '';
        PackageModel model = PackageModel(
          title: title,
          desc: desc,
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
