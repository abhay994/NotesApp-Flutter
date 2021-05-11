import 'dart:io';
import 'dart:convert';
import 'package:stackfinance/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesController{
  File image;
  var imageBase64;
  String imageString='';

  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final newPasswordformKey = GlobalKey<FormState>();
  final TextEditingController titleController =
  new TextEditingController();

  final TextEditingController descriptionController =
  new TextEditingController();

  final TextEditingController newPasswordController =
  new TextEditingController();



  String validateTitle(String value) {

    if (value.length<6)
      return "Title should be greater than 10 charaters";
    else
      return null;
  }


  String validateDescription(String value) {

    if (value.length<6)
      return "Description should be greater than 20 charaters";
    else
      return null;
  }

  String validatePassword(String value) {

    if (value.length<6)
      return "Password should be greater than 6 charaters";
    else
      return null;
  }



  void addNoteSubmit(BuildContext context) async {


    String imageToString = image!=null?  base64Encode(image?.readAsBytesSync()):"";

    if(formKey.currentState.validate()){
  await services.addNote(
      NotesModel(
          id:services.uuidGeneration(),
          title:titleController.text,
          description:descriptionController.text,
          timeStamp: services.timeStamp(),
          onlineBackup: 'no',
          image:imageToString
      )).then((value){

    titleController.text='';
    descriptionController.text='';
    Navigator.pop(context);});

}





  }



  void editNoteSubmit(BuildContext context,String id) async {


    String imageToString = image!=null?  base64Encode(image?.readAsBytesSync()):imageString;


print(imageToString);

      if(formKey.currentState.validate()){
      await services.updateNote(
          NotesModel(
              id:id,
              title:titleController.text,
              description:descriptionController.text,
              timeStamp: services.timeStamp(),
              onlineBackup: 'no',
               image:imageToString,

          )).then((value){

        titleController.text='';
        descriptionController.text='';
        Navigator.pop(context)

        ;});

    }





  }



  void checkConnectionStream(BuildContext context){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
         services.offlineDataBackup();


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("online"),duration: Duration(milliseconds: 100)));



      } else{



          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("offline"),duration: Duration(milliseconds: 100),));



      }
    });

  }

  
  Future<void> resetPasword(BuildContext context) async {
    
    


    await  FirebaseAuth.instance.sendPasswordResetEmail(email: services.currenUser().email).then((value)  async {
     services.signOut(context);
      Navigator.pop(context);

      }
      ).catchError((e) {
      services.signOut(context);

       print(e);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(e),));



        Future.delayed(Duration(milliseconds: 500),(){
          Navigator.pop(context);
        });

      });

  }



}