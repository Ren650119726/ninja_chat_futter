// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:intl/intl.dart';

class TimeAgo {
  RegExp expForParameterOut = RegExp(r"{{[^]+}}");
  RegExp expForParameter = RegExp(r"(?:\{{)[^}]*(?=\}})");

  List<String> dayMap() {
    return [
      "昨天",
      "前天",
    ];
  }

  String replaceParameterForTemplate(Match value) {
    final String? parameter = expForParameter.stringMatch(value[0] ?? "");
    return "\$$parameter".replaceAll("{", "");
  }


  List<String> weekdayMap() {
    return ['', "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期天"];
  }

  String getYearMonthDate(DateTime dateTime) {
    String month = dateTime.month.toString();
    String date = dateTime.day.toString();
    return dateTime.year.toString() + '/' + (month.length == 1 ? '0' : '') + month + '/' + (date.length == 1 ? '0' : '') + date;
  }

  String getMonthDate(DateTime dateTime) {
    String month = dateTime.month.toString();
    String date = dateTime.day.toString();
    return (month.length == 1 ? '0' : '') + month + '/' + (date.length == 1 ? '0' : '') + date;
  }

  String? getTimeStringForChat(int timeStamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    final DateTime epochLimit = DateTime.utc(1971);

    if (date.isBefore(epochLimit)) {
      return null;
    }

    final Duration duration = DateTime.now().difference(date);
    final int diffDays = duration.inDays + (duration.inMinutes > DateTime.now().difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inMinutes ? 1 : 0);
    final int diffMinutes = duration.inMinutes;

    var res;

    // 一个礼拜之内
    if (diffDays > 0 && diffDays < 7) {
      if (diffDays <= 2) {
        res = dayMap()[diffDays - 1];
      } else {
        res = weekdayMap()[date.weekday];
      }
    } else if (diffDays >= 7) {
      //当年内
      if (date.year == DateTime.now().year) {
        res = getMonthDate(date);
      } else {
        res = getYearMonthDate(date);
      }
    } else {
      if (diffMinutes > 1) {
        if (diffMinutes < 60) {
          final String option2 = diffMinutes.toString();
          res = '$option2 分钟前';
        } else {
          res = "${date.hour}:${date.minute < 10 ? "0" + date.minute.toString() : date.minute}";
          // res = "$prefix $timeStr";
        }
      } else {
        res = "现在";
      }
    }

    return res;
  }

  String getTimeForMessage(int timeStamp) {
    var nowTime = DateTime.now();
    nowTime = DateTime(nowTime.year, nowTime.month, nowTime.day);
    var ftime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    // var preFix = ftime.hour >= 12 ? "下午") : "上午");
    final timeStr = DateFormat('HH:mm').format(ftime); // Use 'HH:mm' for 24-hour format
    // 一年外 年月日 + 时间 (24小时制)
    if (nowTime.year != ftime.year) {
      return '${DateFormat('yyyy-MM-dd').format(ftime)} $timeStr';
    }
    // 一年内一周外 月日 + 时间 (24小时制）
    if (ftime.isBefore(nowTime.subtract(const Duration(days: 6)))) {
      return '${DateFormat('MM-dd').format(ftime)} $timeStr';
    }
    // 一周内一天外 星期 + 时间 (24小时制）
    if (ftime.isBefore(nowTime.subtract(const Duration(days: 1)))) {
      return '${weekdayMap()[ftime.weekday]} $timeStr';
    }
    // 昨日 昨天 + 时间 (24小时制)
    if (nowTime.day != ftime.day) {
      String option2 = timeStr;
      return "昨天 $option2";
    }
    // 同年月日 时间 (24小时制)
    return timeStr;
  }
}
