import 'package:must_eat_place_app/model/restaurant.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler{

  Future<Database>initializeDB()async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path,'musteatplace.db'),
      onCreate: (db, version)async{
      await db.execute(
        "create table musteatplace (id integer primary key autoincrement, name text, phone text, lat text, lng text, image blob, estimate text, initdate text)"
        );
      },
      version: 1,
    );
  }

  //--QUERY--
  Future<List<Restaurant>>queryRestaurant()async{
    final Database db = await initializeDB(); 
    final List<Map<String, Object?>> queryResults =
      await db.rawQuery('select * from musteatplace');
    return queryResults.map((e) => Restaurant.fromMap(e)).toList();
  }


  //--INSERT--
Future<int> insertRestaurant(Restaurant restaurant) async {
  int result = 0;
  final Database db = await initializeDB();
  result = await db.rawInsert(
    'insert into musteatplace(name, phone, lat, lng, image, estimate, initdate) values (?,?,?,?,?,?,CURRENT_TIMESTAMP)',
    [
      restaurant.name,
      restaurant.phone,
      restaurant.lat,
      restaurant.lng,
      restaurant.image,
      restaurant.estimate,
    ],
  );
  return result;
}

//--UPDATE--
Future<void> updateRestaurant(Restaurant restaurant) async {
  final Database db = await initializeDB(); 
  await db.rawUpdate(
    'update musteatplace set name=?, phone=?, lat=?, lng=?, image=?, estimate=?, initdate=CURRENT_TIMESTAMP where id=?',
    [
      restaurant.name,
      restaurant.phone,
      restaurant.lat,
      restaurant.lng,
      restaurant.image,
      restaurant.estimate,
      restaurant.id,
    ],
  );
}


  //--DELETE--
Future<void>deleteRestaurant(int id)async{
  final Database db = await initializeDB();
  await db.rawDelete(
    'delete from musteatplace where id=?',
    [id]
  );
}




}