import 'package:aqueduct/aqueduct.dart';

class Feedback {

  Feedback(this.clientId, this.lectureId, this.message, this.sentiment);

  String clientId;
  String lectureId;
  String message;
  int sentiment;

  }