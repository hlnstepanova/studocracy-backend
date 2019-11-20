import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../model/lecture.dart';

class LectureController extends ResourceController{
  LectureController(this.context);
  final ManagedContext context;
  List<Lecture> _lectures = [
    Lecture("lectureId3","Betriebssysteme", DateTime.now().add(const Duration(minutes: 90)), new ManagedSet(), new ManagedSet()),
    Lecture("lectureId4","HSCodesign", DateTime.now().add(const Duration(minutes: 90)), new ManagedSet(), new ManagedSet())/*,
    Lecture.sample(
      "lectureId1",
      "AppDev and bla",
      DateTime.now().add(const Duration(minutes: 90)),
        [
          Rating("c1", "lectureId1", "speedRatings", 2.5),
          Rating("c3", "lectureId1", "speedRatings", 9.0),
          Rating("c2", "lectureId1", "speedRatings", 8.0)
        ],
        [
          Rating("c1", "lectureId1", "sizeRatings", 4.4),
          Rating("c3", "lectureId1", "sizeRatings", 5.6)
        ],
        [
          Rating("c1", "lectureId1", "interestRatings", 2.1),
          Rating("c2", "lectureId1", "interestRatings", 5.2),
          Rating("c3", "lectureId1", "interestRatings", 9.3)
        ],
        [
          Feedback("c1","lectureId1","Cool lecture", 8),
          Feedback("c2","lectureId1","Nice shirt", 9),
          Feedback("c3","lectureId1","Don't understand", 6),
          Feedback("c3","lectureId1","Boring", 1),
          Feedback("c1","lectureId1","Want to sleep", 3)
        ]
    ),
    Lecture.sample(
        "lectureId2",
        "IKT",
        DateTime.now().add(const Duration(minutes: 90)),
        {
          "speedRatings" : [
            Rating("c1", "lectureId2", "speedRatings", 1.5),
            Rating("c3", "lectureId2", "speedRatings", 7.7),
            Rating("c2", "lectureId2", "speedRatings", 6.7)
          ],

          "sizeRatings" : [
            Rating("c1", "lectureId2", "sizeRatings", 1.6),
            Rating("c3", "lectureId2", "sizeRatings", 2.3)
          ],

          "interestRatings" : [
            Rating("c1", "lectureId2", "interestRatings", 3.3),
            Rating("c2", "lectureId2", "interestRatings", 4.2),
            Rating("c3", "lectureId2", "interestRatings", 5.9)
          ]
        },
        [
          Feedback("c1","lectureId2","Cool", 8),
          Feedback("c2","lectureId2","Nice", 9),
          Feedback("c3","lectureId2","Wow", 10),
          Feedback("c3","lectureId2","Very oring", 1),
          Feedback("c1","lectureId2","Can I go?", 3)
        ]
    )*/
  ];

  @Operation.get()
  Future<Response> getAllLectures() async {
    final query = Query<LectureDBmodel>(context);
    return Response.ok(await query.fetch());
  }

  @Operation.get('id', 'category')
  Future<Response>getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async{
    final lecture = _lectures.firstWhere((lecture)=>lecture.id==id,
    orElse: ()=>null);
    if (lecture == null){
      return Response.notFound();
    }

    final ratings = lecture.ratings;

    final result = ratings.map((rating) => rating.value).reduce((a, b) => a + b) / ratings.length;
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
  Future<Response>createLecture(@Bind.body() LectureDBmodel lectureDBmodel) async{
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    lectureDBmodel.id = generateId(await fetchLecturesQuery.fetch());
    final inserLecturesQuery = Query<LectureDBmodel>(context)
    ..values = lectureDBmodel;
    final insertedLecture = await inserLecturesQuery.insert();
    return Response.ok(insertedLecture);
  }

  String generateId(List<Lecture> allLectures)  {
     final Set occupiedNames = <LectureDBmodel>{};
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

}