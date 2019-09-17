import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../scope_models/MainModel.dart';

class SplashScreen extends StatefulWidget {
  final MainModel model;
  SplashScreen({@required this.model});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await widget.model.initModel();
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  Widget _loadingWidget() {
    return Center(
      child: SpinKitRing(
        size: 80.0,
        controller: AnimationController(
            vsync: this, duration: Duration(milliseconds: 800)),
        color: Colors.red,
      ),
    );
  }

  Widget _buildBody() {
    return _loadingWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
