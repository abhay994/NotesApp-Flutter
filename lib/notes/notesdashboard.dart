
import 'dart:convert';

import 'package:stackfinance/exports.dart';
import 'package:stackfinance/notes/createnotes.dart';
import 'package:stackfinance/notes/editnotes.dart';
import 'package:stackfinance/notes/notescontroller.dart';


class NotesDashboard extends StatefulWidget {
  @override
  _NotesDashboardState createState() => _NotesDashboardState();
}

class _NotesDashboardState extends State<NotesDashboard> {

  final  notesController=new NotesController();

  @override
  void initState() {
    services.tokenCheck(context);
    // TODO: implement initState
    super.initState();
     services.offlineDataBackup();





  }




  @override
  Widget build(BuildContext context) {
    notesController.checkConnectionStream(context);
    return WillPopScope(
      onWillPop:()=>null,
      child: SafeArea(

        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text("Notes App",style: TextStyle(color: Colors.black),),

              ),
              body: Container(
                child: StreamBuilder(stream: services.notesJson, builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                    List<Map> data = snapshot.data.reversed.toList();

                  if(snapshot.hasData){
                      return data!=null? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder:(context,index){
                         var image= base64Decode(data[index]['image']);


                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              splashColor: Colors.lightBlue.shade50,
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>NotesEdit(data:data[index])));
                              },
                              child: Container(

                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 10,
                                        child: Container(
                                            height: 150,
                                            width: 150,
                                            color: Colors.blueAccent,

                                            child: image!=null?Image.memory(image,fit: BoxFit.cover,):

                                        Container(),
                                        )
                                      ),
                                    ),

                                    Expanded(
                                      child: Column(
                                        children: [
                                          Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(data[index]['title'],),
                                          )),

                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(data[index]['description'],overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );

                        },

                      ):Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{

                      return Container();
                    }
                  //return Container();

                }),

              ),


              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: ()=>   Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>CreateNotes())),
                child: Icon(Icons.add),
                elevation: 2.0,
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    InkWell(
                      onTap: () async{
                       services.getUserInfo().then((curentUserInfo)  {
                         print(curentUserInfo);
                     _modalBottomResetPassword(curentUserInfo['loginType']);

                       });

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Reset Password",style: TextStyle(color: Colors.black)),
                      ),
                    ),

                    InkWell(
                        onTap: (){
                          services.signOut(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Sign Out",style: TextStyle(color: Colors.black)),
                        )),



                  ],
                ),

              ),


            )
          ],
        ),
      ),
    );
  }

  void _modalBottomResetPassword(String loginType) {
    print(loginType);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (builder) {
          return new Container(


              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:loginType =='GoogleAuthentication'?Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Only Email Registered Users Can Reset Password"),
                  ),
                ):Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Send a password reset link to your email  ${services.currenUser().email} ")),
                      ),
                      // Form(
                      //   key: notesController.newPasswordformKey,
                      //   child:Stack(
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(top: 5,bottom: 5),
                      //         child: TextFormField(
                      //           style: TextStyle(fontSize: 10),
                      //           obscureText: true,
                      //           obscuringCharacter: "*",
                      //           controller: notesController.newPasswordController,
                      //
                      //           decoration: InputDecoration(
                      //             border: OutlineInputBorder(),
                      //             labelText: 'Enter New Password',
                      //
                      //
                      //
                      //           ),
                      //           keyboardType: TextInputType.text,
                      //
                      //           onChanged: (value){
                      //
                      //           },
                      //           validator: notesController.validatePassword,
                      //
                      //
                      //
                      //         ),
                      //       ),
                      //     ],
                      //   ) ,
                      // ),

                      TextButton(onPressed: (){
               notesController.resetPasword(context);

                      }, child:Text("Send and logout") )

                    ],
                  ),

                ),
              ));
        });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    services.disposeServices();
  }
}
