import 'package:social_network_utilities/utilities/builders/builders.dart';

class BuilderDateData {
  final DateTime startDate;
  final DateTime endDate;

  const BuilderDateData({required this.startDate, required this.endDate});
}

class BuilderDateController extends BuilderSegmentController<BuilderDateData?> {
  BuilderDateController({
    this.initialEndDate,
    this.initialStartDate,
  });

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  late final startDateController = DatePickerController(date: initialStartDate);
  late final endDateController = DatePickerController(date: initialEndDate);

  @override
  BuilderDateData? get data => isValid
      ? BuilderDateData(
          startDate: startDateController.date!,
          endDate: endDateController.date!)
      : null;


  @override
  List<String> get errorMesseges => [
        if (startDateController.date == null) "Başlangıç tarihi boş kalamaz",
        if (endDateController.date == null) "Bitiş tarihi boş olamaz"
      ];
}
