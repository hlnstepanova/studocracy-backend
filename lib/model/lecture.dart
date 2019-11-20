import 'package:studocracy_backend/studocracy_backend.dart';
import 'feedback.dart';
import 'rating.dart';

class LectureDBmodel extends ManagedObject<Lecture> implements Lecture{}

class Lecture {

  Lecture(this.id, this.title, this.endTime, this.ratings, this.feedbackList);

  @Column(primaryKey: true)
  String id;
  String clientId;
  String title;
  DateTime endTime;
  ManagedSet<RatingDBmodel> ratings;
  ManagedSet<FeedbackDBmodel> feedbackList;

}