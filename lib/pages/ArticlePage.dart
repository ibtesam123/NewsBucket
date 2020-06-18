import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/NewsModel.dart';
import '../scope_models/MainModel.dart';
import '../utils/CustomColors.dart';
import '../utils/DarkModeEnum.dart';

class ArticlePage extends StatefulWidget {
  final NewsModel article;
  ArticlePage({@required this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  double _height, _width;

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height * 0.08),
      child: Container(
        padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/back_arrow.png'),
                      fit: BoxFit.contain),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleTitle() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          margin: EdgeInsets.only(top: _height * 0.21),
          height: _height * 0.3,
          width: _width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.transparent,
                Colors.black12,
                Colors.black26,
                Colors.black38,
                Colors.black54
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
              padding: EdgeInsets.only(left: 30.0, top: 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.article.category,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: _width,
                    child: Text(
                      widget.article.title.length > 74
                          ? widget.article.title.substring(0, 74) + '...'
                          : widget.article.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Livvic',
                          fontSize: 22.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 15.0,
                        width: 15.0,
                        child: Image.asset(
                          'assets/images/clock.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        '8 April 2019',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _buildArticleImage() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Stack(
          children: <Widget>[
            Container(
              width: _width,
              height: _height * 0.52,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.article.imageUrl),
                    fit: BoxFit.cover),
              ),
            ),
            _buildArticleTitle(),
          ],
        );
      },
    );
  }

  String _makeAuthor(String author) {
    if (author.contains('https'))
      return 'Unknown';
    else
      return author;
  }

  Widget _buildAuthor() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(model.getMode == Mode.DARK
                    ? 'assets/images/authorDark.png'
                    : 'assets/images/author.png'),
                backgroundColor:
                    model.getMode == Mode.DARK ? Colors.black87 : Colors.white,
                radius: 18.0,
              ),
              SizedBox(width: 10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.article.author == ''
                        ? 'Unknown'
                        : _makeAuthor(widget.article.author),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: model.getMode == Mode.DARK
                            ? Colors.white
                            : Colors.black),
                  ),
                  Text(
                    widget.article.source,
                    style: TextStyle(
                        color: model.getMode == Mode.DARK
                            ? Colors.white70
                            : CustomColors.color1),
                  )
                ],
              ),
              Expanded(child: SizedBox()),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     height: 24.0,
              //     width: 24.0,
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: AssetImage('assets/images/bookmarked.png'),
              //             fit: BoxFit.contain)),
              //   ),
              // ),
              SizedBox(width: 15.0),
              GestureDetector(
                  onTap: () async {
                    if (await canLaunch(widget.article.url)) {
                      await launch(widget.article.url);
                    } else {
                      print('Cannot Launch');
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 24.0,
                        width: 24.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(model.getMode == Mode.DARK
                                    ? 'assets/images/webLinkDark.png'
                                    : 'assets/images/webLink.png'),
                                fit: BoxFit.contain)),
                      ),
                      SizedBox(height: 5.0),
                      Text('Link',
                          style: TextStyle(
                              color: model.getMode == Mode.DARK
                                  ? Colors.white70
                                  : CustomColors.color1))
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
            height: _height * 0.52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color:
                    model.getMode == Mode.DARK ? Colors.black : Colors.white),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAuthor(),
                SizedBox(height: 15.0),
                Container(
                  height: _height * 0.38,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        widget.article.description,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: model.getMode == Mode.DARK
                                ? Colors.white
                                : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        child: Stack(
          children: <Widget>[
            _buildArticleImage(),
            Align(
              child: _buildContent(),
              alignment: Alignment.bottomCenter,
            ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
