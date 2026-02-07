import 'package:casa/src/core/models/enums/e_screen_type.dart';
import 'package:flutter/widgets.dart';

class Layout {
  // region Parameters

  /// Devicetype the app is running on
  final EScreenType screenType;

  /// Screen width in pixels
  final double width;

  /// Screen height in pixels
  final double height;

  /// Orientation of the device
  final Orientation orientation;

  // endregion

  // region Constructors

  const Layout({
    required this.screenType,
    required this.width,
    required this.height,
    required this.orientation,
  });

  factory Layout.fromConstraints(BuildContext context, BoxConstraints constraints) {
    final orientation = MediaQuery.orientationOf(context);
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    return Layout(
      screenType: getScreenType(width),
      width: width,
      height: height,
      orientation: orientation,
    );
  }

  // endregion

  // region Methods

  static EScreenType getScreenType(double width) {
    if (width < 600) {
      return EScreenType.mobil;
    } else if (width > 600 && width < 1200) {
      return EScreenType.tablet;
    } else {
      return EScreenType.landscape;
    }
  }

  // endregion
}
