import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShopGridItem extends StatelessWidget {
  int id;
  String image;
  String title;
  String brand;
  int amount;
  int rating;
  int noOfRating;

  ShopGridItem(
      {this.id,
      this.image,
      this.title,
      this.brand,
      this.amount,
      this.rating,
      this.noOfRating});

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(
        3,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: DEVICE_SIZE.width * 0.5,
            padding: EdgeInsets.only(top: 2),
            child: Column(
              children: [
                Container(
                  height: DEVICE_SIZE.width * 0.2,
                  width: DEVICE_SIZE.width * 0.2,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Image.network(this.image),
                ),
                Container(
                  padding: EdgeInsets.only(left: DEVICE_SIZE.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        this.brand,
                        style: TextStyle(fontFamily: 'Montserrat'),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "₹ " + this.amount.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: 'Montserrat'),
                      ),
                      Container(
                        child: RatingBar(
                          initialRating: this.rating != null
                              ? this.rating.ceilToDouble()
                              : 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0),
                          itemSize: 20,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          // onRatingUpdate: (rating) {
                          //   print(rating);
                          // },
                        ),
                      ),
                      this.noOfRating != null
                          ? Text("(" + this.noOfRating.toString() + ")",
                              style: TextStyle(fontFamily: 'Montserrat'))
                          : Text("(0)",
                              style: TextStyle(fontFamily: 'Montserrat')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
