import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/model/rating.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class RatingController extends ResourceController {
  RatingController(this.context);

  final ManagedContext context;

  // TODO: filter category
  @Operation.get('id', 'category')
  Future<Response> getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async{
    final fetchRatingsByLectureId = Query<LectureDBmodel>(context)
      ..join(set: (lecture) => lecture.ratings)
      ..where((lecture) => lecture.id).equalTo(id);
    final lecture = await fetchRatingsByLectureId.fetchOne();
    if(lecture == null) {
      return Response.notFound();
    }
    return Response.ok(lecture.ratings);
  }

  @Operation.get('id')
  Future<Response> getRating(@Bind.path('id') String id) async{
    final fetchRatingsByLectureId = Query<LectureDBmodel>(context)
      ..join(set: (lecture) => lecture.ratings)
      ..where((lecture) => lecture.id).equalTo(id);
    final lecture = await fetchRatingsByLectureId.fetchOne();
    if(lecture == null) {
      return Response.notFound();
    }
    return Response.ok(lecture.ratings);
  }

  /*
  clientId needs to be provided by client, not by server,
  although it works for lectures somehow...
  */
  @Operation.post('id')
  Future<Response> giveRating(@Bind.path('id') String id, @Bind.body() RatingDBmodel ratingDBmodel) async {
    final fetchLectureByIdQuery = Query<LectureDBmodel>(context)
      ..where((l) => l.id).equalTo(id);
    final lecture = await fetchLectureByIdQuery.fetchOne();
    if(lecture == null) {
      return Response.notFound();
    }
    // ratingDBmodel.clientId = request.raw.connectionInfo.remoteAddress.address;
    ratingDBmodel.lecture = lecture;
    final insertRatingQuery = Query<RatingDBmodel>(context)
      ..values = ratingDBmodel;
    final insertedRating = await insertRatingQuery.insert();
    return Response.ok(insertedRating);
  }
}