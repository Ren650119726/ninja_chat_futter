import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart'; // For compatibility with flutter web.
import 'package:image_size_getter/image_size_getter.dart' hide Size;

import '../localization/stream_chat_localizations.dart';
import '../localization/translations.dart';
import '../misc/stream_svg_icon.dart';

int _byteUnitConversionFactor = 1024;

/// int extensions
extension IntExtension on int {
  /// Parses int in bytes to human readable size. Like: 17 KB
  /// instead of 17524 bytes;
  String toHumanReadableSize() {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(this) / log(_byteUnitConversionFactor)).floor();
    final numberValue =
        (this / pow(_byteUnitConversionFactor, i)).toStringAsFixed(2);
    final suffix = suffixes[i];
    return '$numberValue $suffix';
  }
}

/// Durations extensions.
extension DurationExtension on Duration {
  /// Transforms Duration to a minutes and seconds time. Like: 04:13.
  String toMinutesAndSeconds() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

/// String extension
extension StringExtension on String {
  /// Returns the capitalized string
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Returns the biggest line of a text.
  String biggestLine() {
    if (contains('\n')) {
      return split('\n')
          .reduce((curr, next) => curr.length > next.length ? curr : next);
    } else {
      return this;
    }
  }

  /// Returns whether the string contains only emoji's or not.
  ///
  ///  Emojis guidelines
  ///  1 to 3 emojis: big size with no text bubble.
  ///  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    final trimmedString = trim();
    if (trimmedString.isEmpty) return false;
    if (trimmedString.characters.length > 3) return false;
    final emojiRegex = RegExp(
      r'^(\u00a9|\u00ae|\u200d|[\ufe00-\ufe0f]|[\u2600-\u27FF]|[\u2300-\u2bFF]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+$',
      multiLine: true,
      caseSensitive: false,
    );
    return emojiRegex.hasMatch(trimmedString);
  }

  /// Removes accents and diacritics from the given String.
  String get diacriticsInsensitive => removeDiacritics(this);
}

/// List extension
extension IterableExtension<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1).toList(growable: false);
}

/// Extension on [InputDecoration]
extension InputDecorationX on InputDecoration {
  /// Merges this [InputDecoration] with the [other]
  InputDecoration merge(InputDecoration? other) {
    if (other == null) return this;
    return copyWith(
      icon: other.icon,
      labelText: other.labelText,
      labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      helperText: other.helperText,
      helperStyle: helperStyle?.merge(other.helperStyle) ?? other.helperStyle,
      helperMaxLines: other.helperMaxLines,
      hintText: other.hintText,
      hintStyle: hintStyle?.merge(other.hintStyle) ?? other.hintStyle,
      hintTextDirection: other.hintTextDirection,
      hintMaxLines: other.hintMaxLines,
      errorText: other.errorText,
      errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
      errorMaxLines: other.errorMaxLines,
      floatingLabelBehavior: other.floatingLabelBehavior,
      isCollapsed: other.isCollapsed,
      isDense: other.isDense,
      contentPadding: other.contentPadding,
      prefixIcon: other.prefixIcon,
      prefix: other.prefix,
      prefixText: other.prefixText,
      prefixIconConstraints: other.prefixIconConstraints,
      prefixStyle: prefixStyle?.merge(other.prefixStyle) ?? other.prefixStyle,
      suffixIcon: other.suffixIcon,
      suffix: other.suffix,
      suffixText: other.suffixText,
      suffixStyle: suffixStyle?.merge(other.suffixStyle) ?? other.suffixStyle,
      suffixIconConstraints: other.suffixIconConstraints,
      counter: other.counter,
      counterText: other.counterText,
      counterStyle:
          counterStyle?.merge(other.counterStyle) ?? other.counterStyle,
      filled: other.filled,
      fillColor: other.fillColor,
      focusColor: other.focusColor,
      hoverColor: other.hoverColor,
      errorBorder: other.errorBorder,
      focusedBorder: other.focusedBorder,
      focusedErrorBorder: other.focusedErrorBorder,
      disabledBorder: other.disabledBorder,
      enabledBorder: other.enabledBorder,
      border: other.border,
      enabled: other.enabled,
      semanticCounterText: other.semanticCounterText,
      alignLabelWithHint: other.alignLabelWithHint,
    );
  }
}

/// Gets text scale factor through context
extension BuildContextX on BuildContext {
  // ignore: public_member_api_docs
  double get textScaleFactor =>
      // ignore: deprecated_member_use
      MediaQuery.maybeOf(this)?.textScaleFactor ?? 1.0;

  /// Retrieves current translations according to locale
  /// Defaults to [DefaultTranslations]
  Translations get translations =>
      StreamChatLocalizations.of(this) ?? DefaultTranslations.instance;
}

/// Extension on [BorderRadius]
extension FlipBorder on BorderRadius {
  /// Flips borders (Y)
  BorderRadius mirrorBorderIfReversed({bool reverse = true}) => reverse
      ? BorderRadius.only(
          topLeft: topRight,
          topRight: topLeft,
          bottomLeft: bottomRight,
          bottomRight: bottomLeft,
        )
      : this;
}

/// Extension on [IconButton]
extension IconButtonX on IconButton {
  /// Creates a copy of [IconButton] with specified attributes overridden.
  IconButton copyWith({
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool? autofocus,
    String? tooltip,
    bool? enableFeedback,
    BoxConstraints? constraints,
    Widget? icon,
  }) {
    return IconButton(
      iconSize: iconSize ?? this.iconSize,
      visualDensity: visualDensity ?? this.visualDensity,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      splashRadius: splashRadius ?? this.splashRadius,
      color: color ?? this.color,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashColor: splashColor ?? this.splashColor,
      disabledColor: disabledColor ?? this.disabledColor,
      onPressed: onPressed ?? this.onPressed,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      tooltip: tooltip ?? this.tooltip,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      constraints: constraints ?? this.constraints,
      icon: icon ?? this.icon,
    );
  }
}

/// Useful extensions on [FileType]
extension FileTypeX on FileType {
  /// Converts the [FileType] to a [String].
  String toAttachmentType() {
    switch (this) {
      case FileType.image:
        return 'image';
      case FileType.video:
        return 'video';
      case FileType.audio:
        return 'audio';
      case FileType.any:
      case FileType.media:
      case FileType.custom:
        return 'file';
    }
  }
}

/// Useful extensions on [StreamSvgIcon].
extension StreamSvgIconX on StreamSvgIcon {
  /// Converts the [StreamSvgIcon] to a [StreamIconThemeSvgIcon].
  StreamIconThemeSvgIcon toIconThemeSvgIcon() {
    return StreamIconThemeSvgIcon.fromStreamSvgIcon(this);
  }
}

/// Useful extensions on [BoxConstraints].
extension ConstraintsX on BoxConstraints {
  /// Returns new box constraints that tightens the max width and max height
  /// to the given [size].
  BoxConstraints tightenMaxSize(Size? size) {
    if (size == null) return this;
    return copyWith(
      maxWidth: clampDouble(size.width, minWidth, maxWidth),
      maxHeight: clampDouble(size.height, minHeight, maxHeight),
    );
  }
}
