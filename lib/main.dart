import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/HomePage.dart';
import './pages/SplashScreen.dart';
import './scope_models/MainModel.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatefulWidget {
  @override
  _MyMaterialState createState() => _MyMaterialState();
}

class _MyMaterialState extends State<MyMaterial> {
  MainModel _model;

  @override
  void initState() {
    super.initState();
    _model = MainModel();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => SplashScreen(model: _model),
          '/HomePage': (BuildContext context) => HomePage(),
        },
        builder: (BuildContext context, Widget child) {
          return ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child,
          );
        },
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
