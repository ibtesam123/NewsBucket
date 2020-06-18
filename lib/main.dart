import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/HomePage.dart';
import './pages/SplashScreen.dart';
import './scope_models/MainModel.dart';

void main() {
  final MainModel _model = MainModel();
  runApp(MyMaterial(model: _model));
}

class MyMaterial extends StatelessWidget {
  final MainModel model;

  MyMaterial({@required this.model});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => SplashScreen(),
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
