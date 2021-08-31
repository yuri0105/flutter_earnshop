import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CheckoutItem extends StatelessWidget {
  String productImage;
  String brand;
  String title;
  double rating;
  int amount;

  CheckoutItem({
    this.title,
    this.brand,
    this.productImage,
    this.rating,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Container(
                height: DEVICE_SIZE.width * 0.2,
                width: DEVICE_SIZE.width * 0.2,
                margin: EdgeInsets.only(right: 15),
                child: this.productImage != null
                    ? Image.network(this.productImage)
                    : Image.asset('assets/icons/user.png'),
              ),
              Container(
                width: DEVICE_SIZE.width * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.title,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      this.brand,
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "₹ " + this.amount.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark,
                    fontFamily: 'Montserrat'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
