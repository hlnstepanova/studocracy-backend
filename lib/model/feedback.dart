import 'package:studocracy_backend/studocracy_backend.dart';

class Feedback extends Serializable{

  Feedback(this.clientId, this.lectureId, this.message, this.sentiment);

  String clientId;
  String lectureId;
  String message;
  int sentiment;

  @override
  Map<String, dynamic> asMap() => {
      "clientId": clientId,
      "lectureId": lectureId,
      "message": message,
      "sentiment": sentiment
    };

  @override
  void readFromMap(Map<String, dynamic> inputMap) {
    clientId = inputMap['clientId'] as String;
    lectureId = inputMap['lectureId'] as String;
    message = inputMap['message'] as String;
    sentiment = inputMap['clientId'] as int;
  }

  }