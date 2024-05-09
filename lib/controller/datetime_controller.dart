import '../model/datetime_model.dart';

class DateTimeController {
  final DateTimeModel _model = DateTimeModel();

  String getFormattedDate() {
    return _model.getFormattedDate();
  } 
  String getFormattedTime() {
    return _model.getFormattedTime();
  }
}
