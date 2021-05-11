

import 'package:stackfinance/exports.dart';
import 'package:stackfinance/notes/notescontroller.dart';

class CreateNotes extends StatefulWidget {
  @override
  _CreateNotesState createState() => _CreateNotesState();
}




class _CreateNotesState extends State<CreateNotes> {

  final  notesController=new NotesController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
        children: [


          Form(
            key: notesController.formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(


                    children: [



                      notesController.image != null ? Stack(

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 5,
                              child: Container(
                                  height: MediaQuery.of(context).size.height*0.27,
                                  width: MediaQuery.of(context).size.height*0.27,
                                  child: Image.file(notesController.image,fit: BoxFit.fill,)),
                            ),
                          ),
                          Positioned(
                              top: -1,
                              child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      notesController.image=null;
                                    });

                                  },

                                  child: Icon(Icons.cancel,color: Colors.redAccent,)))

                        ],

                      ) :
                      InkWell(onTap: (){
                            _modalBottomSheetImagePick(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: MediaQuery.of(context).size.height*0.17,
                                width: MediaQuery.of(context).size.height*0.4,
                                child: Image.asset("assets/uploadimage.png")),
                          )),





                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Card(
                          elevation: 3,
                          child: TextFormField(
                            style:TextStyle(fontSize: 10),


                            controller: notesController.titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),


                              labelText: 'Enter Title',

                            ),
                            keyboardType: TextInputType.text,

                            onChanged: (value) {},
                            validator: notesController.validateTitle,

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Card(
                          elevation: 3,
                          child: TextFormField(
                            style:TextStyle(fontSize: 10),
                            maxLines: 10,
                            controller: notesController.descriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),

                              labelText: 'Enter Description',

                            ),
                            keyboardType: TextInputType.text,

                            onChanged: (value) {},
                            validator: notesController.validateDescription,

                          ),
                        ),
                      ),






                    ],
                  ),
                ),
              ),
            ),
          )
        ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>notesController.addNoteSubmit(context),
        child: Icon(Icons.save_outlined),
      ),
    );
  }

  void _modalBottomSheetImagePick(BuildContext context) {
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
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            Future.delayed(Duration(milliseconds: 200), () {
                              getImageCamera();
                            });

                          },
                          child: Text("Camera"),)),

                        Expanded(child: TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();

                            Future.delayed(Duration(milliseconds: 200), () {
                              getImageGallary();
                            });


                          },
                          child: Text("Gallary"),))
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 200,
                  //   width: 200,
                  //   child: _buildQrView(context),
                  //
                  // ),

                  // TextField(),
                  // TextField(),
                  // TextField(),
                  // TextField(),
                ],
              ));
        });
  }

  Future getImageCamera() async {
    final pickedFile = await notesController.picker.getImage(source: ImageSource.camera,
        imageQuality: 20
    );
    // print( await getFileSize(pickedFile.path,1 ));
    setState(() {
      if (pickedFile != null) {
        notesController.image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageGallary() async {
    final pickedFile = await notesController.picker.getImage(source: ImageSource.gallery,
        imageQuality: 20
    );

    setState(() {
      if (pickedFile != null) {
        notesController.image = File(pickedFile.path);




      } else {
        print('No image selected.');
      }
    });
  }





}
