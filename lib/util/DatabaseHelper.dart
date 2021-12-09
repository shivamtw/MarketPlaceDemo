import 'package:register_local_data/model/ProductModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String todoTable = 'todosssssaaa_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colEmail='email';
  String colAddress= 'address';
  String colDate = 'date';
  String colPicture = 'picture';
  static final dbVersion = 1;

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todosssssaaa.db';

    // Open/create the database at a given path
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }
  // Future<Database> db = getDatabasesPath().then((String path) {
  //   return openDatabase(
  //     join(path, dbName),
  //     onCreate: (Database db, int version) async {
  //       await db.execute(
  //           "CREATE TABLE $scheduledShiftGroupsTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, uniqueGroupId TEXT, nightShiftCount INTEGER, dayShiftCount INTEGER, weekEnding INTEGER, estimatedIncome REAL");
  //     },
  //     version: 1,
  //   );
  // });
  void _createDb(Database db, int newVersion) async {

    await db.execute(
        'CREATE TABLE $todoTable('
            '$colId INTEGER PRIMARY KEY,'
            '$colTitle TEXT,'
            '$colDescription TEXT,'
            '$colEmail TEXT,'
            '$colAddress TEXT,'
            '$colDate TEXT,'
            '$colPicture TEXT)'
    );
    // await db.execute(
    //     'CREATE TABLE $todoTable('
    //         '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
    //         '$colTitle TEXT,'
    //         ' $colDescription TEXT, '
    //         '$colPicture TEXT'
    //         '$colDate TEXT,'
    //         );

  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(todoTable, orderBy: '$colTitle ASC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertTodo(ProductDetailModel todo) async {
    Database db = await this.database;

    var result = await db.insert(todoTable, todo.toMap(),);
    return result;
    print(result);
  }



  // Future<Contact> saveContact(Contact contact) async {
  //   var dbContact = await db;
  //   contact.id = await dbContact.insert(contactTable, contact.toMap());
  //   return contact;
  // }



  // Update Operation: Update a todo object and save it to database
  Future<int> updateTodo(ProductDetailModel todo) async {
    var db = await this.database;
    var result = await db.update(todoTable, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }


  // Delete Operation: Delete a todo object from database
  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $todoTable WHERE $colId = $id');
    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $todoTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<ProductDetailModel>> getTodoList() async {
    Database db = await this.database;

    var todoMapList = await getTodoMapList(); // Get 'Map List' from database
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<ProductDetailModel> todoList = List<ProductDetailModel>();
    List listMap = await db.rawQuery('SELECT * FROM $todoTable');

    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(ProductDetailModel.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }

  // Future<List> getAllContacts() async {
  //   var dbContact = await db;
  //   List listMap = await dbContact.rawQuery('SELECT * FROM $contactTable');
  //   var listContact = <Contact>[];
  //   for (Map m in listMap) {
  //     listContact.add(Contact.fromMap(m));
  //   }
  //   return listContact;
  // }



}