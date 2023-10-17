import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:social_network_utilities/utilities/utilities.dart';

class QRWidget extends StatelessWidget {
  const QRWidget({Key? key, required this.data}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return SocialUtilCard(
        padding: const EdgeInsets.all(20),
        child: ExpandablePanel(
            theme: const ExpandableThemeData(hasIcon: false),
            controller: ExpandableController(),
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageService().data.sharable.qrTitle,
                    style: const TextStyle(
                        fontSize: 17, fontFamily: ThemeService.headlineFont)),
                const Divider(),
                const SizedBox(height: 5),
              ],
            ),
            collapsed: const SizedBox(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LanguageService().data.sharable.qrExplantation,
                    style: const TextStyle(color: ThemeService.unusedColor)),
                const SizedBox(height: 15),
                QrImageView(
                  padding: EdgeInsets.zero,
                  data: data,
                  version: QrVersions.auto,
                )
              ],
            )));
  }
}
