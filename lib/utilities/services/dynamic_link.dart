import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:social_network_utilities/utilities/utilities.dart';

class DynamicLinkService {
  final String dynamicLinkPrefix;
  final String androidPackageName;
  final String iosBundleId;
  final String iosIpadBundleId;

  final void Function(String type, int id) onLinkPressed;

  DynamicLinkService(
      {required this.dynamicLinkPrefix,
      required this.onLinkPressed,
      required this.androidPackageName,
      required this.iosBundleId,
      required this.iosIpadBundleId});

  void handleLinks(BuildContext context) {
    FirebaseDynamicLinks.instance.onLink.listen((data) {
      handleUri(data.link, context);
    });
  }

  Future<Uri> createLink(String type, int id) async {
    final link = "${LanguageService().data.siteLink}$type/$id";
    final params = DynamicLinkParameters(
        link: Uri.parse(link),
        uriPrefix: dynamicLinkPrefix,
        androidParameters: AndroidParameters(packageName: androidPackageName),
        iosParameters: IOSParameters(
            bundleId: iosBundleId, ipadBundleId: iosIpadBundleId));

    return (await FirebaseDynamicLinks.instance.buildShortLink(params))
        .shortUrl;
  }

  Future<void> handleUri(Uri link, BuildContext context) async {
    final pathItems = link.path.split('/');
    final id = int.parse(pathItems.removeLast());
    final type = pathItems.removeLast();

    onLinkPressed(type, id);
  }
}
