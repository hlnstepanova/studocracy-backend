import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class FeedbackDBmodel extends ManagedObject<Feedback> implements Feedback{}

class Feedback extends Serializable{

  Feedback(this.clientId, this.lecture, this.message, this.sentiment);

  @primaryKey
  String clientId;
  @Relate(#feedbackList)
  LectureDBmodel lecture;
  String message;
  int sentiment;

  @override
  Map<String, dynamic> asMap() => {
      "clientId": clientId,
      "lectureId": lecture.id,
      "message": message,
      "sentiment": sentiment
    };

  @override
  void readFromMap(Map<String, dynamic> object) {
    clientId = object['clientId'] as String;
    lecture = object['lectureId'] as LectureDBmodel;
    message = object['message'] as String;
    sentiment = object['clientId'] as int;
  }

  }