import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:remindits/model/article_model.dart';
import 'package:remindits/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtickelWidget extends StatefulWidget {
  const ArtickelWidget({
    super.key,
  });

  @override
  State<ArtickelWidget> createState() => _ArtickelWidgetState();
}

class _ArtickelWidgetState extends State<ArtickelWidget> {
  List<Article> articles = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse(
        'https://www.detik.com/search/searchnews?query=tips+kesehatan');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('div.media__text > h3 > a')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urls = html
        .querySelectorAll('div.media__image > a')
        .map(
          (element) => '${element.attributes['href']}',
        )
        .toList();

    final urlImages = html
        .querySelectorAll('div.media__image > a > span > img')
        .map((element) => element.attributes['src']!)
        .toList();

    print('Count: ${urls.length}');
    setState(
      () {
        articles = List.generate(
          titles.length,
          (index) => Article(
              url: urls[index],
              title: titles[index],
              urlImage: urlImages[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "News",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: "SFProText"),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            leading: Image.network(
              article.urlImage,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
            title: Text(
              article.title,
              style: TextStyle(fontFamily: "SFProText"),
            ),
            subtitle: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.primaryColor1),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () async {
                try {
                  await launchUrl(Uri.parse(article.url));
                } catch (e) {
                  print(article.url);
                }
              },
              child: Text(
                'Learn more',
                style: TextStyle(fontFamily: "SFProText"),
              ),
            ),
          );
        },
      ),
    );
  }
}
