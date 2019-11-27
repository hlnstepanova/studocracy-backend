import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../model/lecture.dart';

class LectureController extends ResourceController{
  LectureController(this.context);
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllLectures() async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    return Response.ok(await fetchLecturesQuery.fetch());
  }

  @Operation.post()
  Future<Response> createLecture(@Bind.body() LectureDBmodel lectureDBmodel) async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    print(lectureDBmodel.id);
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
     if (occupiedNames.isEmpty){
       return "lecture0";
     }
     for(int i = 0; i >= 0; i++) {
       if(!occupiedNames.contains("lecture${i}")) {
         return"lecture${i}";
       }
     }
     return null;
  }

}