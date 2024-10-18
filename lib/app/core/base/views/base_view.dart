import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utitlity/responsive_settings.dart';
import 'desktop_view.dart';
import 'phone_view.dart';
import 'tablet_view.dart';

abstract class BaseView extends GetResponsiveView {
  BaseView({super.key, super.settings = const AppResponsiveSetting()});

  @override
  Widget? tablet() {
    return BaseTabletView(
      vBuilderTablet: vBuilderTablet(),
    );
  }

  @override
  Widget? desktop() {
    return BaseDesktopView(
      vBuilderDesktop: vBuilderDesktop(),
    );
  }

  @override
  Widget? phone() {
    return BaseMobileView(
      vBuilderMobile: vBuilderPhone(),
    );
  }

  Widget vBuilderPhone();
  Widget vBuilderDesktop();
  Widget vBuilderTablet();
}
