import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizeExtension on num {
  /// Font Size
  double get sp => ScreenUtil().setSp(this);

  /// Width
  double get w => ScreenUtil().setWidth(this);

  /// Height
  double get h => ScreenUtil().setHeight(this);

  /// Radius
  double get r => ScreenUtil().radius(this);
}
