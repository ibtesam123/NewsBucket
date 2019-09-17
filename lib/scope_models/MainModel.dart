import 'package:scoped_model/scoped_model.dart';

import './ConnectedModel.dart';

class MainModel extends Model with ConnectedModel,OperateModel,UtilityModel {}
