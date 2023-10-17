import 'package:social_network_utilities/utilities/utilities.dart';

abstract class BuilderPublisher<T extends Model>
    extends BuilderSegmentController<T> {
  BuilderWarningsController get warningsController;
  ModelService<T> get modelService;

  @override
  T? get data;

  bool get isUpdating;
  ItemParameters? get itemParameters;

  BuilderPublisher();

  Future<T?> publish() async {
    if (errorMesseges.isNotEmpty) {
      if (warningsController.onError != null) {
        for (var e in errorMesseges) {
          warningsController.onError!(e);
        }
      }

      return null;
    }

    return modelService.postItem(item: data!);
  }

  Future<T?> update() async {
    if (errorMesseges.isNotEmpty) {
      if (warningsController.onError != null) {
        for (var e in errorMesseges) {
          warningsController.onError!(e);
        }
      }

      return null;
    }

    return modelService.updateItem(
        updatedItem: data!, itemParameters: itemParameters!);
  }

  List<MediaData?> get media;

  Future<T?> onDone() async {
    return isUpdating ? await update() : await publish();
  }
}
