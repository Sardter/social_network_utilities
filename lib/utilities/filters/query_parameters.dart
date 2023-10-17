import 'package:social_network_utilities/utilities/utilities.dart';
import 'package:flutter/widgets.dart';

class QueryParameters<T extends Model> {
  final String? searchQuery;
  final int pageSize;
  final bool notHidden;

  const QueryParameters(
      {required this.searchQuery,
      this.pageSize = 10,
      this.notHidden = false});

  String fieldStringify<K>(K? field, String Function(K field) toStr) {
    if (field == null) return "";
    return toStr(field);
  }

  List<String?> get defaultFieldsToStr => [
        fieldStringify<String>(searchQuery, (field) => "search_text=$field"),
        fieldStringify<int>(pageSize, (field) => "page_size=$field"),
        fieldStringify<bool>(notHidden,
            (field) => "filter_mode=${!field ? 'regular' : 'hidden'}"),
        ...fieldsToStr
      ];

  @protected
  List<String?> get fieldsToStr => [];

  @override
  String toString() {
    return defaultFieldsToStr.where((element) => element != null && element.isNotEmpty).join('&');
  }
}
