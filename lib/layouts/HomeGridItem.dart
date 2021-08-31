import 'package:EarnShow/utils/helpers.dart';
import 'package:flutter/material.dart';

class HomeGridItem extends StatelessWidget {
  final iconImage;
  final label;
  final route;

  HomeGridItem(this.iconImage, this.label, this.route);

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => routeTo(context, this.route, {}),
      child: Container(
        width: DEVICE_SIZE.width * 0.3,
        height: DEVICE_SIZE.width * 0.3,
        margin: EdgeInsets.only(bottom: DEVICE_SIZE.height * 0.01),
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              this.iconImage,
              height: 25,
              color: Color(
                0xffF9AA33,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                this.label,
                style: TextStyle(
                  letterSpacing: 1,
                  color: Theme.of(context).primaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
