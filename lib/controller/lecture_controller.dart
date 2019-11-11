import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import 'package:uuid/uuid.dart';
import '../model/feedback.dart';
import '../model/lecture.dart';
import '../model/lecture_posted.dart';
import '../model/rating.dart';

class LectureController extends ResourceController{
  var uuid = Uuid();
  final _lectures = [
    Lecture("lectureId1","AppDev and bla", DateTime.now().add(const Duration(minutes: 90))),
    Lecture("lectureId2","IKT", DateTime.now().add(const Duration(minutes: 90))),
    Lecture("lectureId3","Betriebssysteme", DateTime.now().add(const Duration(minutes: 90))),
    Lecture("lectureId4","HSCodesign", DateTime.now().add(const Duration(minutes: 90))),
  ];

  @Operation.get()
  Future<Response> getAllLectures() async {
    return Response.ok(_lectures);
  }

  @Operation.get('id', 'category')
  Future<Response>getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async{
    final lecture = _lectures.firstWhere((lecture)=>lecture.id==id,
    orElse: ()=>null);
    if (lecture == null){
      return Response.notFound();
    }

    final ratings = lecture.ratings[category];

    var result = ratings.map((rating) => rating.value).reduce((a, b) => a + b) / ratings.length;
    return Response.ok(result);
  }

  @Operation.get('id')
  Future<Response>getFeedbackList(@Bind.path('id') String id) async{
    final lecture = _lectures.firstWhere((lecture)=>lecture.id==id,
        orElse: ()=>null);
    if (lecture == null){
      return Response.notFound();
    }

    return Response.ok(lecture.feedbackList);
  }

  @Operation.post()
  Future<Response>createLecture(@Bind.body() LecturePosted lecturePosted) async{

    String id = uuid.v4();
    var lecture = Lecture(id, lecturePosted.title, lecturePosted.endTime);
    _lectures.add(lecture);

    return Response.ok(lecture);
  }


}