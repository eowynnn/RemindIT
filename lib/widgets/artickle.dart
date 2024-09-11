import 'package:flutter/material.dart';
// import 'package:remindits/Screen/artickel_screen.dart';
import 'package:remindits/model/package_model.dart';
import 'package:remindits/services/http_service.dart';
import 'package:remindits/services/scraper_service.dart';

class ArtickelWidget extends StatefulWidget {
  const ArtickelWidget({
    super.key,
  });

  @override
  State<ArtickelWidget> createState() => _ArtickelWidgetState();
}

class _ArtickelWidgetState extends State<ArtickelWidget> {
  List<PackageModel> list = [];
  Future<void> getPackage() async {
    list.clear();
    setState(() {});
    final html = await HttpService.get();
    if (html != null) list = ScraperService.run(html);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(list[index].title, style: TextStyle(color: Colors.black),),
            subtitle: Text(list[index].desc),
            trailing: Text(list[index].link),
            onTap: () {},
          );
        },
      ),
    );
    // Container(
    //   height: 140,
    //   width: 400,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(15),
    //     color: Color(0xffE6F7FF),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               "Ideal Hours for Sleep",
    //               style: TextStyle(
    //                 fontFamily: "SFProText",
    //               ),
    //             ),
    //             Text("8hours 30minutes",
    //                 style: TextStyle(
    //                   color: Color(0xFF16C1E3),
    //                   fontFamily: "SFProText",
    //                 )),
    //             SizedBox(
    //               height: 15,
    //             ),
    //             Container(
    //               height: 35,
    //               width: 106,
    //               decoration: BoxDecoration(
    //                   color: Color(0xff42DCF9),
    //                   borderRadius: BorderRadius.circular(20)),
    //               child: Material(
    //                 borderRadius: BorderRadius.circular(20),
    //                 color: Colors.transparent,
    //                 child: InkWell(
    //                   borderRadius: BorderRadius.circular(20),
    //                   onTap: () {
    //                     Navigator.push(context, _createRoute(ArtickelPage()));
    //                   },
    //                   child: Center(
    //                     child: Text(
    //                       "Learn More",
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 12,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       Container(
    //           padding: EdgeInsets.symmetric(
    //               vertical: 16, horizontal: media.width * 0.02),
    //           child: Image(image: AssetImage("assets/png/Icon-Bed.png")))
    //     ],
    //   ),
    // );
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
