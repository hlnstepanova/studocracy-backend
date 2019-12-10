import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class FeedbackDBmodel extends ManagedObject<Feedback> implements Feedback{}

class Feedback {

  @Column(primaryKey: true)
  String clientId;
  String message;
  DateTime created;
  int sentiment;

  @Relate(#feedbackList)
  LectureDBmodel lecture;
}