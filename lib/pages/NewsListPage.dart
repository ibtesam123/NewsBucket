import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/CustomColors.dart';
import '../models/NewsModel.dart';
import '../pages/ArticlePage.dart';
import '../utils/DarkModeEnum.dart';

class NewsListPage extends StatelessWidget {
  double _height, _width;
  final List<NewsModel> list;
  final BuildContext context;
  final Mode mode;

  NewsListPage(
      {@required this.list, @required this.context, @required this.mode});

  void _initialize() {
    this._height = MediaQuery.of(context).size.height;
    this._width = MediaQuery.of(context).size.width;
  }

  Widget _buildHighlightNews() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ArticlePage(index: 0)));
      },
      child: Container(
        height: _height * 0.35,
        width: _width,
        child: Stack(
          children: <Widget>[
            Container(
              height: _height * 0.35,
              width: _width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(list[0].imageUrl),
                    fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: _width,
                height: (_height * 0.5) / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black12,
                      Colors.black26,
                      Colors.black38,
                      Colors.black38,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: _height * 0.15, left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    list[0].category,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: _width * 0.6,
                    height: _height * 0.15,
                    child: Text(
                      list[0].title.length > 60
                          ? list[0].title.substring(0, 60) + '...'
                          : list[0].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleNewsItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ArticlePage(index: index)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(list[index].imageUrl),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              height: _width * 0.2,
              width: _width * 0.2,
            ),
            SizedBox(width: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: _width * 0.6,
                  child: Text(
                    list[index].title.length > 65
                        ? list[index].title.substring(0, 65) + '...'
                        : list[index].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mode == Mode.DARK ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: _width * 0.6,
                  child: Text(
                    list[index].author == null || list[index].author == ''
                        ? 'Source:  ' + list[index].source
                        : 'Author:  ' + list[index].author,
                    style: TextStyle(
                        color: mode == Mode.DARK
                            ? Colors.white60
                            : CustomColors.color1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    int i;
    List<Widget> _newsItems = List<Widget>();
    for (i = 1; i < list.length; i++) {
      _newsItems.add(_buildSingleNewsItem(context, i));
    }
    return Column(children: _newsItems);
  }

  @override
  Widget build(BuildContext context) {
    _initialize();
    return ListView(
      children: <Widget>[
        _buildHighlightNews(),
        SizedBox(height: 30.0),
        Text('Latest',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: mode == Mode.DARK ? Colors.white : Colors.black)),
        _buildNewsList(),
      ],
    );
  }
}
