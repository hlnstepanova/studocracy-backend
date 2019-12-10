import 'package:studocracy_backend/studocracy_backend.dart';
import 'feedback.dart';
import 'rating.dart';

class LectureDBmodel extends ManagedObject<Lecture> implements Lecture{}

class Lecture {

  @Column(primaryKey: true)
  String id;
  String title;
  DateTime endTime;
  ManagedSet<RatingDBmodel> ratings;
  ManagedSet<FeedbackDBmodel> feedbackList;

}