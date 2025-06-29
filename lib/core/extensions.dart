extension DateTimeExtensions on DateTime{
  bool isBefore(DateTime other) => compareTo(other) == -1;
  bool isAfter(DateTime other) => compareTo(other) == 1;
  String toDateString() => "$day/$month/$year";
  String toTimeString() => "$hour:$minute:$second";
  String toDateTimeString() => "$year-$month-$day $hour:$minute:$second";

}