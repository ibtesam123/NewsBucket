import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/CustomColors.dart';
import '../pages/NewsListPage.dart';
import '../scope_models/MainModel.dart';
import '../utils/DarkModeEnum.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double _height, _width;
  PageController _newsFeedPageController = PageController();
  PageController _navigationPageController =
      PageController(viewportFraction: 0.8);

  void _initialize() {
    this._height = MediaQuery.of(context).size.height;
    this._width = MediaQuery.of(context).size.width;
  }

  Widget _buildAppBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(_height * 0.08),
        child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Container(
              padding:
                  EdgeInsets.only(right: 20.0, left: 20.0, top: _height * 0.05),
              color: model.getMode == Mode.DARK ? Colors.black87 : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(model.getMode == Mode.DARK
                              ? 'assets/images/menuDark.png'
                              : 'assets/images/menu.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      model.toggleMode();
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(model.getMode == Mode.DARK
                          ? 'assets/images/dark.png'
                          : 'assets/images/light.png'),
                      radius: 16.0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildNavigationBar() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        TextStyle _selected = TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: model.getMode == Mode.DARK ? Colors.white : Colors.black);
        TextStyle _notSelected = TextStyle(
            fontSize: 20.0,
            color: model.getMode == Mode.DARK
                ? Colors.white60
                : CustomColors.color1);
        return Container(
          width: MediaQuery.of(context).size.width,
          height: _height * 0.04,
          color: model.getMode == Mode.DARK ? Colors.black87 : Colors.white,
          child: PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Text('${model.categoryList[index]}',
                    style:
                        model.currentPage == index ? _selected : _notSelected),
              );
            },
            itemCount: 6,
            controller: _navigationPageController,
            physics: NeverScrollableScrollPhysics(),
          ),
        );
      },
    );
  }

  Widget _buildHeading() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Today',
                  style: TextStyle(
                      fontSize: 35.0,
                      fontFamily: 'Livvic',
                      fontWeight: FontWeight.bold,
                      color: model.getMode == Mode.DARK
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 25.0, bottom: 15.0),
                  child: _buildNavigationBar()),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingWidget() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SpinKitRipple(
                size: 60.0,
                controller: AnimationController(
                    vsync: this, duration: Duration(milliseconds: 800)),
                color: model.getMode == Mode.DARK
                    ? Colors.white60
                    : CustomColors.color1,
              ),
              SizedBox(height: 10.0),
              Text('Fetching News...',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Livvic',
                      color: model.getMode == Mode.DARK
                          ? Colors.white60
                          : CustomColors.color1))
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          height: _height * 0.6,
          padding: EdgeInsets.only(top: 15.0),
          width: _width,
          child: PageView.builder(
            // pageSnapping: true,
            itemBuilder: (BuildContext context, int index) {
              return model.isLoading
                  ? _loadingWidget()
                  : Container(
                      padding: EdgeInsets.only(left: 30.0),
                      child: NewsListPage(
                        context: context,
                        list: model.newsList[model.currentPage],
                        mode: model.getMode,
                      ),
                    );
            },
            itemCount: 6,
            controller: _newsFeedPageController,
            onPageChanged: (int pageNo) async {
              print(pageNo.toString());
              _navigationPageController.animateToPage(pageNo,
                  duration: Duration(milliseconds: 600), curve: Curves.ease);
              model.loadCategory(pageNo: pageNo, forceReload: false);
            },
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeading(),
          _buildPageView(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initialize();
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor:
              model.getMode == Mode.DARK ? Colors.black87 : Colors.white,
          body: _buildBody(),
        );
      },
    );
  }
}
