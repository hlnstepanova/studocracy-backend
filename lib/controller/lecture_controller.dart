import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../model/lecture.dart';

class LectureController extends ResourceController{
  LectureController(this.context);
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllLectures() async {
    removeOldLectures();
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    List<LectureDBmodel> lectures = await fetchLecturesQuery.fetch();
    lectures.retainWhere((lecture) => lecture.endTime.difference(DateTime.now()).inSeconds < 0);
    return Response.ok(await fetchLecturesQuery.fetch());
  }

  @Operation.post()
  Future<Response> createLecture(@Bind.body() LectureDBmodel lectureDBmodel) async {
    removeOldLectures();
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

  void removeOldLectures() async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    final DateTime now = DateTime.now();
    final List<LectureDBmodel> lectures = await fetchLecturesQuery.fetch();
    for(int i = 0; i < lectures.length; i++){
      if(lectures[i].endTime.difference(now).inSeconds < 0){
        final deleteOldLectureQuery =  Query<LectureDBmodel>(context)..where((l) => l.id).equalTo(lectures[i].id);
        await deleteOldLectureQuery.delete();
      }
    }
  }

}