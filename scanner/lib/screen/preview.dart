import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:scanner/provider/imagefile.dart';

class Preview extends StatefulWidget {
  Preview({Key key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final _pageviewController =
      PageController(initialPage: 0, viewportFraction: 0.8);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<File> images = Provider.of<ImageFiles>(context).itemss;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: null,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 5 * MediaQuery.of(context).size.height / 7,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageviewController,
                onPageChanged: (value) => setState(
                  () {
                    currentPage = value;
                  },
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  bool active = currentPage == index;
                  return buildCard(active, index, images);
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        _pageviewController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOutQuint,
                        );
                        setState(
                          () {
                            currentPage = index;
                            print(index);
                          },
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        child: Container(
                          child: Image.file(
                            images[index],
                            fit: BoxFit.fill,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // height: 10,
                          width: 60,
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildCard(bool active, int index, List<File> images) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 60 : 150;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      child: Image.file(
        images[index],
        fit: BoxFit.fill,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: active ? Colors.green : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: blur,
            offset: Offset(offset, offset),
          )
        ],
      ),
    );
  }
}
