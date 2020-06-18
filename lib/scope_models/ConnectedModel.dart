import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/NewsModel.dart';
import '../utils/DarkModeEnum.dart';

mixin ConnectedModel on Model {
  int _currentPageNo = 0;
  bool _isLoading = false;
  List<String> _categoryList = [
    'General',
    'Technology',
    'Science',
    'Sports',
    'Health',
    'Business',
  ];
  List<NewsModel> _general, _business, _science, _health, _sports, _technology;
  List<List<NewsModel>> _newsList;
  Mode _mode;
  SharedPreferences _prefs;
}

mixin OperateModel on ConnectedModel {
  Future<void> loadCategory(
      {@required int pageNo, @required bool forceReload}) async {
    _currentPageNo = pageNo;
    _isLoading = true;
    notifyListeners();

    if (!forceReload) {
      if (_newsList[pageNo].length != 0) {
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    
    String _apiKey= <Enter YOUR API_KEY HERE>;   // Get it from https://newsapi.org 
    String _loadURL;

    if (_categoryList[pageNo] == 'general')
      _loadURL =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=$_apiKey";
    else
      _loadURL =
          "https://newsapi.org/v2/top-headlines?country=in&category=${_categoryList[pageNo]}&apiKey=$_apiKey";

    http.Response _response = await http.get(_loadURL);
    Map json = JSON.jsonDecode(_response.body);
    List<NewsModel> _list = List<NewsModel>();
    for (Map article in json['articles']) {
      NewsModel _model = NewsModel(
        author: article['author'] == null ? '' : article['author'],
        category: _categoryList[pageNo].toUpperCase(),
        description:
            article['description'] == null ? '' : article['description'],
        imageUrl: article['urlToImage'] == null ? '' : article['urlToImage'],
        isBookmarked: false,
        publishDate:
            article['publishedAt'] == null ? '' : article['publishedAt'],
        source:
            article['source']['name'] == null ? '' : article['source']['name'],
        title: article['title'] == null ? '' : article['title'],
        url: article['url'] == null ? '' : article['url'],
      );
      if (_model.imageUrl.contains('file://') ||
          !_model.imageUrl.contains('https') ||
          _model.description == '' ||
          _model.description == null) continue;
      _list.add(_model);
    }
    _newsList[pageNo] = _list;

    if (pageNo == _currentPageNo) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initModel() async {
    _prefs = await SharedPreferences.getInstance();
    bool _isDark = _prefs.getBool('isDark');
    if (_isDark == null) _isDark = false;
    if (_isDark)
      _mode = Mode.DARK;
    else
      _mode = Mode.LIGHT;

    _newsList = List<List<NewsModel>>();
    _general = List<NewsModel>();
    _technology = List<NewsModel>();
    _science = List<NewsModel>();
    _sports = List<NewsModel>();
    _health = List<NewsModel>();
    _business = List<NewsModel>();

    _newsList.add(_general);
    _newsList.add(_business);
    _newsList.add(_science);
    _newsList.add(_health);
    _newsList.add(_sports);
    _newsList.add(_technology);
    await loadCategory(pageNo: 0, forceReload: false);
  }

  void toggleMode() {
    if (_mode == Mode.LIGHT) {
      _mode = Mode.DARK;
      _prefs.setBool('isDark', true);
    } else {
      _mode = Mode.LIGHT;
      _prefs.setBool('isDark', false);
    }
    notifyListeners();
  }
}

mixin UtilityModel on ConnectedModel {
  int get currentPage {
    return _currentPageNo;
  }

  List<String> get categoryList {
    return _categoryList;
  }

  List<List<NewsModel>> get newsList {
    return _newsList;
  }

  bool get isLoading {
    return _isLoading;
  }

  Mode get getMode {
    return _mode;
  }
}
