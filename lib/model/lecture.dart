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
    "ratings": {
      "speedRatings" : ratings['speedRatings'].map((rating) => rating.asMap()).toList(),
      "sizeRatings" : ratings['sizeRatings'].map((rating) => rating.asMap()).toList(),
      "interestRatings" : ratings['interestRatings'].map((rating) => rating.asMap()).toList(),
    },
    "feedbackList": feedbackList.map((feedback) => feedback.asMap()).toList(),
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    id = object['id'] as String;
    title = object['title'] as String;
    endTime = object['endTime'] as DateTime;
    ratings = object['ratings'] as Map<String, List<Rating>>;

    //TODO: not sure this will work, need to check
    feedbackList = object['feedbackList'] as List<Feedback>;
  }


}