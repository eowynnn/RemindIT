import 'package:http/http.dart' as http;
const String baseUrl = "https://www.detik.com/search/searchnews?query=tips+pola+hidup+sehat";
class HttpService {
  static Future<String?> get()async{
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) return response.body;
    }catch(e){
      print(e);
    }
    return null;
  }
}