import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scope_models/MainModel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _height, _width;

  @override
  initState() {
    super.initState();
    ScopedModel.of<MainModel>(context, rebuildOnChange: false)
        .initModel()
        .then((_) {
      Navigator.of(context).pushReplacementNamed('/HomePage');
    });
  }

  Widget _buildAppLogo() {
    return Container(
      height: _height * 0.25,
      width: _height * 0.25,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/news.png'),
      )),
    );
  }

  Widget _buildAppText() {
    return Container(
      child: Text(
        'News Bucket',
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Livvic',
            color: Colors.black54),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      padding: EdgeInsets.all(_width * 0.02),
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Loading',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Livvic',
            ),
          ),
          SizedBox(
            width: _width * 0.02,
          ),
          SpinKitCircle(
            color: Colors.blue,
            size: _width * 0.07,
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: SizedBox()),
        _buildAppLogo(),
        _buildAppText(),
        Expanded(child: SizedBox()),
        _buildLoading(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(0, 153, 204, 1));
    return Scaffold(
      body: _buildBody(),
    );
  }
}
