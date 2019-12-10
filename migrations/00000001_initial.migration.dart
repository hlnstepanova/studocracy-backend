import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration1 extends Migration { 
  @override
  Future upgrade() async {
   		database.createTable(SchemaTable("Feedback", [SchemaColumn("clientId", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("message", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("created", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("sentiment", ManagedPropertyType.integer, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.createTable(SchemaTable("Lecture", [SchemaColumn("id", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("title", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("endTime", ManagedPropertyType.datetime, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.createTable(SchemaTable("Rating", [SchemaColumn("clientId", ManagedPropertyType.string, isPrimaryKey: true, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("category", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),SchemaColumn("value", ManagedPropertyType.doublePrecision, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false)]));
		database.addColumn("Feedback", SchemaColumn.relationship("lecture", ManagedPropertyType.string, relatedTableName: "Lecture", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("Rating", SchemaColumn.relationship("lecture", ManagedPropertyType.string, relatedTableName: "Lecture", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    