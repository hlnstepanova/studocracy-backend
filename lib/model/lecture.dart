import 'package:studocracy_backend/studocracy_backend.dart';
import 'feedback.dart';
import 'rating.dart';

class Lecture extends Serializable{

  Lecture(this.id, this.title, this.endTime);
  Lecture.sample(this.id, this.title, this.endTime, this.ratings, this.feedbackList);

  String id;
  String title;
  DateTime endTime;
  Map<String, List<Rating>> ratings = {
    "speedRatings" : [],
    "sizeRatings" : [],
    "interestRatings" : [],
  };
  List<Feedback> feedbackList = [];

  @override
  Map<String, dynamic> asMap() => {
    "id": id,
    "title": title,
    "endTime":  endTime.toIso8601String(),
    "ratings": ratings,
    "feedbackList":feedbackList.asMap(),
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    id = object['id'] as String;
    title = object['title'] as String;
    endTime = object['endTime'] as DateTime;
    ratings = object['ratings'] as Map<String, List<Rating>>;
    feedbackList = object['feedbackList'] as List<Feedback>;
  }


}