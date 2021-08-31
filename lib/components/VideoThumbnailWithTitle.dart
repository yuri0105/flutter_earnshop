import 'package:flutter/material.dart';

class VideoWithTitle extends StatelessWidget {
  final Function onClick;
  final String videoTitle;
  final String creator;
  final String creatorImageURL;
  final int views;
  final int creatorId;
  final String videoThumbnailURL;
  final String duration;

  VideoWithTitle(
      {@required this.videoTitle,
      @required this.onClick,
      @required this.creator,
      @required this.creatorId,
      @required this.creatorImageURL,
      @required this.views,
      @required this.videoThumbnailURL,
      @required this.duration});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              height: 200,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
                image: this.videoThumbnailURL != null
                    ? DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(this.videoThumbnailURL),
                      )
                    : null,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: this.creatorImageURL != null
                        ? Image.network(
                            this.creatorImageURL,
                            width: 40,
                            height: 40,
                          )
                        : Image.asset(
                            'assets/icons/user.png',
                            width: 40,
                            height: 40,
                          ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.videoTitle,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                this.creator,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              Text(
                                this.views != null
                                    ? this.views.toString() + " views"
                                    : "0 views",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
