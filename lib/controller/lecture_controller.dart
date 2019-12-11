
import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/model/feedback.dart';
import 'package:studocracy_backend/model/rating.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../model/lecture.dart';

class LectureController extends ResourceController{
  LectureController(this.context);
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllLectures() async {
    await removeOldLectures(context);
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    return Response.ok(await fetchLecturesQuery.fetch());
  }

  @Operation.post()
  Future<Response> createLecture(@Bind.body() LectureDBmodel lectureDBmodel) async {
    await removeOldLectures(context);
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    lectureDBmodel.id = generateId(await fetchLecturesQuery.fetch());
    final insertLectureQuery = Query<LectureDBmodel>(context)
    ..values = lectureDBmodel;
    final insertedLecture = await insertLectureQuery.insert();
    return Response.ok(insertedLecture);
  }

  String generateId(List<Lecture> allLectures) {
     final Set occupiedNames = <String>{};
     for(Lecture l in allLectures){
       occupiedNames.add(l.id);
     }
     for(int i = 0; i >= 0; i++) {
       if(!occupiedNames.contains("lecture${i}")) {
         return"lecture${i}";
       }
     }
     return null;
  }

  // TODO: The DateTime in the DB seems to be 3 hours later ???
  static Future removeOldLectures(ManagedContext context) async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    final List<LectureDBmodel> lectures = await fetchLecturesQuery.fetch();
    for(int i = 0; i < lectures.length; i++){
      if(lectures[i].endTime.difference(DateTime.now()).inSeconds < 0){
        final deleteOldLectureQuery =  Query<LectureDBmodel>(context)..where((l) => l.id).equalTo(lectures[i].id);
        await deleteOldLectureQuery.delete();
        await _removeOldRatings(lectures[i], context);
        await _removeOldFeedback(lectures[i], context);
      }
    }
  }

  static Future _removeOldRatings(Lecture lecture, ManagedContext context) async {
    final deleteOldRatingsQuery =  Query<RatingDBmodel>(context)..where((r) => r.lecture.id).equalTo(lecture.id);
    await deleteOldRatingsQuery.delete();
  }

   static Future _removeOldFeedback(Lecture lecture, ManagedContext context) async {
    final deleteOldFeedbackQuery =  Query<FeedbackDBmodel>(context)..where((f) => f.lecture.id).equalTo(lecture.id);
    await deleteOldFeedbackQuery.delete();
  }

}