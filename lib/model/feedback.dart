import 'package:aqueduct/aqueduct.dart';

class Feedback implements Serializable{

  Feedback(this.clientId, this.lectureId, this.message, this.sentiment);

  String clientId;
  String lectureId;
  String message;
  int sentiment;

  @override
  Map<String, dynamic> asMap() {
    return {
      "clientId": clientId,
      "lectureId": lectureId,
      "message": message,
      "sentiment": sentiment
    };
  }

  @override
  void readFromMap(Map<String, dynamic> inputMap) {
    clientId = inputMap['clientId'] as String;
    lectureId = inputMap['lectureId'] as String;
    message = inputMap['message'] as String;
    sentiment = inputMap['clientId'] as int;
  }

  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    // not used
    return null;
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    // not used
  }

  }