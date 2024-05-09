class DateTimeModel {
  String getFormattedDate() {
    DateTime now = DateTime.now();
    // Format the date and time as per your requirement
    String formattedDate = "${now.year}-${now.month}-${now.day}";
    return formattedDate;
  }

  String getFormattedTime() {
    DateTime now = DateTime.now();
    // Format the date and time as per your requirement
    String formattedTime = "${now.hour}:${now.minute}:${now.second} ";
    return formattedTime;
  }
}
