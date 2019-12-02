import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/model/rating.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

class RatingController extends ResourceController {
  RatingController(this.context);

  final ManagedContext context;

  //TODO: needs to be tested
  @Operation.get('id', 'category')
  Future<Response> getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async {
    final q = Query<LectureDBmodel>(context)
      ..where((l) => l.id).equalTo(id);

    Query<RatingDBmodel> subQuery = q
        .join(set: (l) => l.ratings)
      ..where((r) => r.category).equalTo(category);

    final averageRating = await subQuery.reduce.average((r) => r.value);
    return Response.ok(averageRating);

    //TODO: how to handle error case?
    //return Response.notFound();

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
    ratingDBmodel.lecture = lecture;
    final insertRatingQuery = Query<RatingDBmodel>(context)
      ..values = ratingDBmodel;
    final insertedRating = await insertRatingQuery.insert();
    return Response.ok(insertedRating);
  }
}