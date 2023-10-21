import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

const localeVN = 'vi_VN';
const localeEnUS = 'en_US';
const localeFormat = localeVN;

extension numEx on num {
  num get safeNum => this;

  String format({String format = '#,##0.##', String unit = ''}) {
    try {
      return '$unit${NumberFormat(format, localeFormat).format(this)}';
    } catch (err) {
      debugPrint("unable to format string double $this - $err");
    }
    return '';
  }
}

extension StringEx on String? {
  bool get isNotNullOrEmpty {
    return this?.isNotEmpty == true;
  }
}

extension IterableExt<T> on Iterable<T>? {
  bool get isNotNullOrEmpty {
    return this?.isNotEmpty == true;
  }

  T? get getFirstOrNull {
    return this.isNotNullOrEmpty ? this?.firstOrNull : null;
  }
}
