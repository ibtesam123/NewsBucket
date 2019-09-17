import 'package:flutter/material.dart';

class NewsModel {
  String category,
      title,
      description,
      source,
      author,
      url,
      imageUrl,
      publishDate;
  bool isBookmarked = false;
  NewsModel(
      {@required this.category,
      @required this.title,
      @required this.description,
      @required this.source,
      @required this.author,
      @required this.url,
      @required this.imageUrl,
      @required this.publishDate,
      @required this.isBookmarked});

  void setBookmark(bool status) {
    this.isBookmarked = status;
  }
}
