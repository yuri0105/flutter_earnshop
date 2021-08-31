import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  String description;
  String image;
  String user;

  Comment({this.description, this.image, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          if (image != null)
            Image.network(
              image,
              width: 50,
              height: 50,
            )
          else
            Image.asset(
              'assets/icons/user.png',
              width: 50,
              height: 50,
            ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null)
                  Text(
                    user,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  )
                else
                  Text(
                    "Comment",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
