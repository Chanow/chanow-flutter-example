String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

  final minutesString =
      minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

  final secondsString =
      seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  return formattedTime;
}

double formatSlider(Duration time) {
  final ms = time.inMilliseconds;
  final se = time.inSeconds;
  final mi = time.inMinutes;
  final ho = time.inHours;

  double timeSecond = (ms ~/ 1000 + se + mi * 60 + ho * 3600).toDouble();

  return timeSecond;
}

Duration sliderTo(double value) {
  Duration position = Duration(seconds: (value ~/ 2).toInt());

  return position;
}
