import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/NewsModel.dart';
import '../pages/ArticlePage.dart';
import '../utils/CustomColors.dart';
import '../utils/DarkModeEnum.dart';

class NewsListPage extends StatefulWidget {
  final List<NewsModel> list;
  final Mode mode;

  NewsListPage({
    @required this.list,
    @required this.mode,
  });

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  double _height, _width;

  Widget _buildHighlightNews() {
    return GestureDetector(
      onTap: () {
        final NewsModel hightlightNews = widget.list[0];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ArticlePage(article: hightlightNews),
          ),
        );
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
                    image: CachedNetworkImageProvider(widget.list[0].imageUrl),
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
                    widget.list[0].category,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: _width * 0.6,
                    height: _height * 0.15,
                    child: Text(
                      widget.list[0].title.length > 60
                          ? widget.list[0].title.substring(0, 60) + '...'
                          : widget.list[0].title,
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

  Widget _buildSingleNewsItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ArticlePage(
              article: widget.list[index],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.list[index].imageUrl),
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
                    widget.list[index].title.length > 65
                        ? widget.list[index].title.substring(0, 65) + '...'
                        : widget.list[index].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.mode == Mode.DARK
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: _width * 0.6,
                  child: Text(
                    widget.list[index].author == null ||
                            widget.list[index].author == ''
                        ? 'Source:  ' + widget.list[index].source
                        : 'Author:  ' + widget.list[index].author,
                    style: TextStyle(
                        color: widget.mode == Mode.DARK
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
    for (i = 1; i < widget.list.length; i++) {
      _newsItems.add(_buildSingleNewsItem(i));
    }
    return Column(children: _newsItems);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        _buildHighlightNews(),
        SizedBox(height: 30.0),
        Text(
          'Latest',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: widget.mode == Mode.DARK ? Colors.white : Colors.black,
          ),
        ),
        _buildNewsList(),
      ],
    );
  }
}
