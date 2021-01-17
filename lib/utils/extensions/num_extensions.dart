import 'package:intl/intl.dart';

extension IntX on int {
  String get toDateMoment {
    final currentDate = DateTime.now();
    final previousDate = DateTime.fromMillisecondsSinceEpoch(this);
    Duration diff = currentDate.difference(previousDate);

    String timeString = '';

    if (diff.inSeconds.abs() < 60) {
      timeString = '${diff.inSeconds.abs()} seconds ago';
    } else if (diff.inMinutes.abs() < 2) {
      timeString = 'a minute ago';
    } else if (diff.inMinutes.abs() < 60) {
      timeString = '${diff.inMinutes.abs()} minutes ago';
    } else if (diff.inHours.abs() < 2) {
      timeString = 'one hour ago';
    } else if (diff.inHours.abs() < 24) {
      timeString = '${diff.inHours.abs()} hours ago';
    } else if (diff.inDays.abs() < 2) {
      timeString = 'one day ago';
    } else {
      timeString = 'at ${previousDate.year}-${previousDate.month}-${previousDate.day}';
    }
    return timeString;
  }

  String get toTime {
    final currentDate = DateTime.now();
    final previousDate = DateTime.fromMillisecondsSinceEpoch(this);
    Duration diff = currentDate.difference(previousDate);

    String timeString = '';

    if (diff.inHours.abs() > 23) {
      timeString = '${previousDate.year}-${previousDate.month}-${previousDate.day}';
    } else {
      final time = DateFormat().add_jm().format(previousDate);
      timeString = time;
    }
    return timeString;
  }
}
