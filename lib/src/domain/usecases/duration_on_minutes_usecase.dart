class ConvertDurationUseCase {
  int? day = 0;
  int? hour = 0;
  int? minutes = 0;

  ConvertDurationUseCase({
    this.day,
    this.hour,
    this.minutes,
  });
  ConvertDurationUseCase execute(int durationInSeconds) {
    int newDay = 0;
    int newHour = 0;
    int newMinutes = 0;
    if (durationInSeconds >= 86400) {
      newDay = (durationInSeconds / 86400).floor();
      int totalDayinSeconds = newDay * 86400;
      newHour = ((durationInSeconds - totalDayinSeconds) / 3600).floor();
      int totalHourinSeconds = newHour * 3600;
      newMinutes =
          ((durationInSeconds - (totalDayinSeconds + totalHourinSeconds)) / 60)
              .round();
      return ConvertDurationUseCase(
        day: newDay,
        hour: newHour,
        minutes: newMinutes,
      );
    } else if (durationInSeconds >= 3600 && durationInSeconds < 86400) {
      newHour = (durationInSeconds / 3600).floor();
      int totalHourinSeconds = newHour * 3600;
      newMinutes = ((durationInSeconds - totalHourinSeconds) / 60).round();
      return ConvertDurationUseCase(
        day: day,
        hour: newHour,
        minutes: newMinutes,
      );
    } else {
      int newMinutes = (durationInSeconds / 60).round();
      return ConvertDurationUseCase(
        day: day,
        hour: hour,
        minutes: newMinutes,
      );
    }
  }
}
