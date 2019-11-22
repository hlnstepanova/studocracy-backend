import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class FeedbackDBmodel extends ManagedObject<Feedback> implements Feedback{}

class Feedback {

  Feedback(this.clientId, this.lecture, this.message, this.sentiment);

  @primaryKey
  String clientId;
  @Relate(#feedbackList)
  LectureDBmodel lecture;
  String message;
  int sentiment;
}