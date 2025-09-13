import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  // Base values
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  // Vertical Spacing Widgets (responsive)
  static SizedBox get vxs => SizedBox(height: xs.h);
  static SizedBox get vsm => SizedBox(height: sm.h);
  static SizedBox get vmd => SizedBox(height: md.h);
  static SizedBox get vlg => SizedBox(height: lg.h);
  static SizedBox get vxl => SizedBox(height: xl.h);
  static SizedBox get vxxl => SizedBox(height: xxl.h);

  // Horizontal Spacing Widgets (responsive)
  static SizedBox get hxs => SizedBox(width: xs.w);
  static SizedBox get hsm => SizedBox(width: sm.w);
  static SizedBox get hmd => SizedBox(width: md.w);
  static SizedBox get hlg => SizedBox(width: lg.w);
  static SizedBox get hxl => SizedBox(width: xl.w);
  static SizedBox get hxxl => SizedBox(width: xxl.w);
}
