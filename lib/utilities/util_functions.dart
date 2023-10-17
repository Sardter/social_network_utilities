import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


bool ifNullThenFalseElse(bool? item) {
  return item != null && item;
}

Iterable<T> uniqueBy<T, V>(Iterable<T> items, V Function(T) attr) {
  var uniqueItemsMap = <V, T>{};

  for (var item in items) {
    var value = attr(item); // Extract value of the attribute
    if (!uniqueItemsMap.containsKey(value)) {
      // Check for uniqueness
      uniqueItemsMap[value] = item;
    }
  }

  return uniqueItemsMap.values;
}

String dateTimeToStr(DateTime date) {
  final min =
      '${date.minute}'.length == 1 ? '0${date.minute}' : '${date.minute}';
  final hour = '${date.hour}'.length == 1 ? '0${date.hour}' : '${date.hour}';
  return '${date.day}/${date.month}/${date.year}, $hour:$min';
}

Future<dynamic> launchPage<T>(BuildContext context, Widget page) async {
  try {
    return await Navigator.push<T>(
      context, MaterialPageRoute(builder: (context) => page));
  } catch (e) {
    return null;
  }
}

void closePage(BuildContext context, {dynamic result}) {
  try {
    Navigator.pop(context, result);
  } catch (e) {
    
  }
}

String getShortNumber(var number) {
  var f = NumberFormat.compact(locale: "tr_TR");
  return f.format(number);
}

