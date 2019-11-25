import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class FeedbackDBmodel extends ManagedObject<Feedback> implements Feedback{}

class Feedback {

  Feedback(this.clientId, this.lecture, this.message, this.sentiment);

  @Column(primaryKey: true)
  String clientId;
  String message;
  int sentiment;

  @Relate(#feedbackList)
  LectureDBmodel lecture;
}