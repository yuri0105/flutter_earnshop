import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review extends StatelessWidget {
  String description;
  int star;
  String creatorName;
  String creatorImageURL;

  Review({this.description, this.creatorName, this.creatorImageURL, this.star});

  @override
  Widget build(BuildContext context) {
    final DEVICE_SIZE = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          creatorImageURL != null
              ? Image.network(
                  creatorImageURL,
                  width: 50,
                  height: 50,
                )
              : Image.asset(
                  "assets/icons/user.png",
                  width: 50,
                  height: 50,
                ),
          Container(
            padding: EdgeInsets.only(left: 20),
            width: DEVICE_SIZE.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      creatorName != null ? creatorName : "User",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    RatingBar(
                      initialRating:
                          star != null ? star.toDouble() : 0.toDouble(),
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
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    description != null ? description : "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
