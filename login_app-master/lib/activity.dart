class Activity {
  String activityId;
  String date;
  String wakeUp;
  String wakeUpImage;
  String totalSteps;
  String totalStepsImage;
  Activity(
      {this.activityId,
      this.date,
      this.wakeUp,
      this.wakeUpImage,
      this.totalSteps,
      this.totalStepsImage});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return new Activity(
      activityId: json['activity_id'] as String,
      date: json['date'] as String,
      wakeUp: json['wakeUp'] as String,
      wakeUpImage: json['wakeUpImage'] as String,
      totalSteps: json['totalSteps'] as String,
      totalStepsImage: json['totalStepsImage'] as String,
    );
  }
}
