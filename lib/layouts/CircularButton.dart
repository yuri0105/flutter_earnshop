import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  Function onTap;
  bool isLoading = false;

  CircularButton({this.onTap, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.1,
        ),
        child: isLoading != null && isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )),
                            onTap: onTap,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ));
  }
}
