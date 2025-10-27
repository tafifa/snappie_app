import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FontSize - A utility class for managing font sizes consistently across the application.
///
/// This class provides predefined font sizes using an enum system, ensuring consistency and
/// readability across the codebase. The sizes are responsive and scalable using `flutter_screenutil`.
///
/// Enum: [FontSizeOption]
///   - xxSmall: 8.sp
///   - xSmall: 9.sp
///   - small: 10.sp
///   - mediumSmall: 11.sp
///   - regular: 14.sp (default)
///   - medium: 16.sp
///   - large: 18.sp
///   - xl: 20.sp
///   - xl2: 22.sp
///   - xl3: 24.sp
///   - xl4: 28.sp
///   - xl5: 32.sp
///   - xl6: 36.sp
///   - xl7: 40.sp
///   - xl8: 48.sp
///   - xl9: 56.sp
///   - xl10: 64.sp
///   - xl11: 72.sp
///   - xl12: 80.sp
///
/// Usage Example:
///
///   // To get a predefined font size:
///   Text(
///     'Hello World',
///     style: TextStyle(
///       fontSize: FontSize.getSize(FontSizeOption.medium),
///     ),
///   );
///
///   // To use a custom font size:
///   Text(
///     'Custom Font',
///     style: TextStyle(
///       fontSize: FontSize.customFontSize(26.0),
///     ),
///   );
///
/// Methods:
///   - [getSize] (FontSizeOption): Returns the corresponding font size for the given enum option.
///   - [customFontSize] (double): Allows for custom font sizes that are scaled using `flutter_screenutil`.

enum FontSizeOption {
  xxSmall,
  xSmall,
  small,
  mediumSmall,
  regular,
  medium,
  large,
  xl,
  xl2,
  xl3,
  xl4,
  xl5,
  xl6,
  xl7,
  xl8,
  xl9,
  xl10,
  xl11,
  xl12,
}

class FontSize {
  static double getSize(FontSizeOption option) {
    switch (option) {
      case FontSizeOption.xxSmall:
        return 8.0.sp;
      case FontSizeOption.xSmall:
        return 9.0.sp;
      case FontSizeOption.small:
        return 10.0.sp;
      case FontSizeOption.mediumSmall:
        return 12.0.sp;
      case FontSizeOption.regular:
        return 14.0.sp;
      case FontSizeOption.medium:
        return 16.0.sp;
      case FontSizeOption.large:
        return 18.0.sp;
      case FontSizeOption.xl:
        return 20.0.sp;
      case FontSizeOption.xl2:
        return 22.0.sp;
      case FontSizeOption.xl3:
        return 24.0.sp;
      case FontSizeOption.xl4:
        return 28.0.sp;
      case FontSizeOption.xl5:
        return 32.0.sp;
      case FontSizeOption.xl6:
        return 36.0.sp;
      case FontSizeOption.xl7:
        return 40.0.sp;
      case FontSizeOption.xl8:
        return 48.0.sp;
      case FontSizeOption.xl9:
        return 56.0.sp;
      case FontSizeOption.xl10:
        return 64.0.sp;
      case FontSizeOption.xl11:
        return 72.0.sp;
      case FontSizeOption.xl12:
        return 80.0.sp;
      }
  }

  static double customFontSize(double size) {
    return size.sp;
  }
}