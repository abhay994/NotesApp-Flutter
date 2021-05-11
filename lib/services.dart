import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:encrypt/encrypt.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stackfinance/models/notesmodel.dart';
import 'package:uuid/uuid.dart';
import 'login/loginScreen.dart' ;
import 'package:flutter/material.dart' as fluttetMaterial;


enum loginType{
  googleAuthentication,
  EmailAndPasswordAuthentication
}

class Services{



  // database name
  static final _databasename = "notesApp.db";
  static final _databaseversion = 1;

  // table names
  static final _databaseTable = "notes";

  static Database database;

  BehaviorSubject<List<Map>> notes;



  Stream<List<Map>> get notesJson => notes.stream;





  Services._privateConstructor(){
    notes = new BehaviorSubject<List<Map>>.seeded([]);


    initSqlDatabase();
  }


  static final Services instance = Services._privateConstructor();


  // ID Generation
  String uuidGeneration()=>Uuid().v1();


  //timeStamp
  String timeStamp()=> DateTime.now().toIso8601String();




  //Firebase Current User
  User currenUser() =>  FirebaseAuth.instance.currentUser;


  //Firebase Current User Info
  Future<Map<String,dynamic>> getUserInfo() async{
    DocumentSnapshot documentSnapshot =  await FirebaseFirestore.instance
        .collection('Users')
        .doc(currenUser().uid)
        .get();

    return documentSnapshot.data();
  }




  //Firebase Create User
  Future<UserCredential> createUser({String email,String password}) async =>
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,

          password: encryptText(text: password)  //Encrypt Password
      );









  //Firebase login User
  Future<UserCredential> loginUser({String email,String password}) async =>
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,

          password:  encryptText(text: password) //Encrypt Password
      );






  //Firebase Google SignIn
  Future<UserCredential> signInWithGoogle() async {


    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn(

    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }






  // Insert Login User Detail In Database
  Future<void> firebaseInsertUserDetail({UserCredential userCredential, String userId,String loginType}) async {
    Map<String, dynamic> data = {
      "UID": userCredential.user.uid,
      "email": userCredential.user.email,
      "loginType":loginType
    };

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential.user.uid)
        .set(data);
  }





  // Text Encryption
  String encryptText({String text}){
    final plainText = text;
    final key = Key.fromUtf8('abhayRastogi32keylenght.........');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
   // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    // print(decrypted);
    // print(encrypted.base64);
    return encrypted.base64;

  }







  // Check Authtype
  String checkAuthtype(var authtype){
    switch(authtype) {
      case loginType.googleAuthentication: return 'GoogleAuthentication';
      break;
      case loginType.EmailAndPasswordAuthentication: return 'EmailandPasswordAuthentication';
      break;
      default:return '';

    }
  }





  // Check Internet
  Future<bool> checkInternet() async{
    bool status=false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      status=true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      status=true;
    }else{

      status = false;
    }

      return status;

  }




  // Initialize Sql DataBase
  Future<void> initSqlDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databasename);
    var exist= await databaseExists(path);
    if(exist){
      print("Database Exist ");

      //await deleteDatabase(path);
      database = await openDatabase(path);
      await getNotes();


    }else{
      print("Database Doesn't Exist ");
      database = await openDatabase(path,
          version: _databaseversion, onCreate: _onCreate);

    }

  }





  // create a database since it doesn't exist
  Future _onCreate(Database db, int version) async {
    // sql code
    var columnID='id';
    var columnOneName="title";
    var columnTwoName="description";
    var columnThreeName="onlineBackup";
    var columnFourName="timeStamp";
    var columnFiveName="image";
    await db.execute('''
      CREATE TABLE $_databaseTable (
        $columnID TEXT PRIMARY KEY,
        $columnOneName TEXT NOT NULL,
        $columnTwoName TEXT NOT NULL,
        $columnThreeName TEXT NOT NULL,
        $columnFourName TEXT  NOT NULL,
        $columnFiveName TEXT  NOT NULL
        
        );
      ''');
  }





  // Check Database Exists !
  Future<bool> databaseExists(String path) async => await databaseFactory.databaseExists(path);



  // Add Notes
  Future<void> addNote(NotesModel notesModel) async{
   print(notesModel.toJson());
    if( await checkInternet()){
      print('internet');

     FirebaseFirestore.instance
          .collection('Users')
          .doc(currenUser().uid)
          .collection('MyNotes')
          .doc(notesModel.id)
          .set(notesModel.toJson(), SetOptions(merge: true)).then((value) async{

            notesModel.onlineBackup ='yes';
            await database.insert(_databaseTable,notesModel.toJson());
            await getNotes();
            await offlineDataBackup();
         })
        .catchError((e)async{

        notesModel.onlineBackup ='no';
        await database.insert(_databaseTable,notesModel.toJson());
        await getNotes();
       });


    }
    else{
      print('no network');
       notesModel.onlineBackup = 'no';
       await  database.insert(_databaseTable,notesModel.toJson());
       await getNotes();
    }

  }


  // Update Notes
  Future<void> updateNote(NotesModel notesModel) async{

    print(notesModel.toJson());
    if( await checkInternet()){
      print('internet');


      FirebaseFirestore.instance
          .collection('Users')
          .doc(currenUser().uid)
          .collection('MyNotes')
          .doc(notesModel.id)
          .set(notesModel.toJson()).then((value) async{

        notesModel.onlineBackup ='yes';
        await database.update(
            _databaseTable, notesModel.toJson(), where: 'id = ?',
            whereArgs: [notesModel.id]);

        await getNotes();

      })
          .catchError((e)async{

        print(e);
        notesModel.onlineBackup ='no';
        await database.update(
            _databaseTable, notesModel.toJson(), where: 'id = ?',
            whereArgs: [notesModel.id]);
        await getNotes();
      });


    }
    else{
      print('no network');
      notesModel.onlineBackup = 'no';
      await database.update(
          _databaseTable, notesModel.toJson(), where: 'id = ?',
          whereArgs: [notesModel.id]);
      await getNotes();
    }

  }




  // Get All Notes
  Future<void> getNotes() async {
    notes.sink.add([]);
 List<Map> data  = await database.rawQuery('SELECT title,onlineBackup FROM $_databaseTable ORDER BY timeStamp');
    print(data);
    notes.sink.add(await database.rawQuery(
        'SELECT * FROM $_databaseTable ORDER BY timeStamp'));
  }





  // offline Backup when Internet is Connected
  Future<void> offlineDataBackup() async{

   try{
     List<Map> notelist = await database.rawQuery("SELECT * FROM $_databaseTable WHERE onlineBackup ='no'");

     NotesModel notesModel;


     if(notelist.isNotEmpty && await checkInternet()){

       for(var data in notelist) {
         notesModel = new NotesModel.fromData(data);
         notesModel.onlineBackup = 'yes';

         FirebaseFirestore.instance
             .collection('Users')
             .doc(currenUser().uid)
             .collection('MyNotes')
             .doc(notesModel.id)
             .set(notesModel.toJson(),SetOptions(merge: true)).then((value) async {

           // await database.insert(_databaseTable,notesModel.toJson());
           await database.update(
               _databaseTable, notesModel.toJson(), where: 'id = ?',
               whereArgs: [notesModel.id]);
           await getNotes();
         })
             .catchError((e) async {
           notesModel.onlineBackup = 'no';

           await database.update(
               _databaseTable, notesModel.toJson(), where: 'id = ?',
               whereArgs: [notesModel.id]);
           await getNotes();
         });
       }

     }

   }catch(e){

   }




  }




  // Data SignIn BackUp
  Future<void> dataSignInBackup() async{

      NotesModel notesModel;
    try{
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currenUser().uid)
          .collection('MyNotes')
          .get()
          .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async{
           print(doc.data());
          notesModel=new NotesModel.fromData(doc.data());
           print(notesModel.toJson());
          await database.insert(_databaseTable,notesModel.toJson());
          // print(doc["first_name"]);
        });
      });

    }catch(e){
      print(e);

    }

  }




  // Token Check
  void tokenCheck(fluttetMaterial.BuildContext context) async{

    if(currenUser()==null){
        fluttetMaterial.Navigator.push(context,fluttetMaterial.MaterialPageRoute(builder: (context)=>LoginScreen()));
    }

  }



  // SignOut Check
  void signOut(fluttetMaterial.BuildContext context)async{
   await FirebaseAuth.instance.signOut();
   await tokenCheck(context);
   await database.delete(_databaseTable);
  }



  void disposeServices(){
    notes.sink?.close();
  }


}