import 'package:EarnShow/layouts/ChromeTab.dart';
import 'package:flutter/material.dart';

class SliderHorizontalListTabsWithTitle extends StatelessWidget {
  String title;
  String image;
  String url;

  SliderHorizontalListTabsWithTitle({this.title, this.image, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {chromeTab(context, url)},
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 3),
                      blurRadius: 2)
                ],
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipOval(
                child: Image.network(image),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
