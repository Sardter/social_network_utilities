import 'package:social_network_utilities/utilities/builders/builders.dart';

class BuilderWarningsController {
  List<BuilderWarning> warnings = [];
  void Function(String errorMessage)? onError;
}
