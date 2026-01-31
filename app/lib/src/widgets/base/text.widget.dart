import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class CasaText extends StatelessWidget {
  final String data;

  final TextStyle? style;

  final TextAlign? textAlign;

  final TextOverflow? textOverflow;

  final int? maxLines;

  final bool? softWrap;

  final TextHeightBehavior? textHeightBehavior;

  final Locale? locale;

  const CasaText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
    this.textHeightBehavior,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isWeb) {
      return SelectableText(
        data,
        textAlign: textAlign,
        style: style,
        maxLines: maxLines,
        textHeightBehavior: textHeightBehavior,
      );
    } else {
      return Text(
        data,
        textAlign: textAlign,
        style: style,
        maxLines: maxLines,
        textHeightBehavior: textHeightBehavior,
        softWrap: softWrap,
        overflow: textOverflow,
        locale: locale,
      );
    }
  }
}
