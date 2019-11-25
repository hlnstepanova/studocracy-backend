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


  @Operation.post('id')
  Future<Response> giveRating(@Bind.path('id') String id, @Bind.body() RatingDBmodel ratingDBmodel) async {
    final lecture = await context.fetchObjectWithID<LectureDBmodel>(id);
    if(lecture == null) {
      return Response.notFound();
    }
    final insertRatingQuery = Query<RatingDBmodel>(context)
    ..values = ratingDBmodel;
    final insertedRating = await insertRatingQuery.insert();
    return Response.ok(insertedRating);
  }
}