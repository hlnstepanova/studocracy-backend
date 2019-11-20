import 'package:studocracy_backend/studocracy_backend.dart';
import 'feedback.dart';
import 'rating.dart';

class LectureDBmodel extends ManagedObject<Lecture> implements Lecture{}

class Lecture extends Serializable{

  Lecture(this.id, this.title, this.endTime, this.ratings, this.feedbackList);

  @Column(primaryKey: true)
  String id;
  String title;
  DateTime endTime;
  ManagedSet<RatingDBmodel> ratings;
  ManagedSet<FeedbackDBmodel> feedbackList;

  @override
  Map<String, dynamic> asMap() => {
    "id": id,
    "title": title,
    "endTime":  endTime.toIso8601String(),
    "ratings": ratings.map((rating) => rating.asMap()).toList(),
    "feedbackList": feedbackList.map((feedback) => feedback.asMap()).toList(),
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    id = object['id'] as String;
    title = object['title'] as String;
    endTime = object['endTime'] as DateTime;
    ratings = object['ratings'] as ManagedSet<RatingDBmodel>;

    //TODO: not sure this will work, need to check
    feedbackList = object['feedbackList'] as ManagedSet<FeedbackDBmodel>;
  }


}