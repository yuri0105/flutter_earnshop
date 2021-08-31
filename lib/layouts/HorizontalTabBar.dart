import 'package:flutter/material.dart';

class HorizontalTabBar extends StatelessWidget {
  final String label;
  final IconData iconName;
  final Function onTap;

  HorizontalTabBar({this.label, this.iconName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.elliptical(5, 5)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(5, 5),
            ),
          ]),
      child: InkWell(
        onTap: this.onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.label,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).secondaryHeaderColor),
            ),
            Icon(iconName)
          ],
        ),
        splashColor: Theme.of(context).primaryColorDark,
      ),
    );
    // return ButtonBar(
    //   buttonMinWidth: MediaQuery.of(context).size.width,
    //   buttonHeight: 55,
    //   children: [
    //     FlatButton(
    //       colorBrightness: r,
    //       child: Text(
    //         this.label,
    //         style: TextStyle(
    //           fontSize: 20,
    //           color: Theme.of(context).secondaryHeaderColor,
    //         ),
    //       ),
    //       color: Colors.blue,
    //       onPressed: () {},
    //     ),
    //   ],
    // );
  }
}
