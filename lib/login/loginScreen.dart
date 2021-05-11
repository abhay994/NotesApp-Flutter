import 'package:stackfinance/exports.dart';
import 'package:stackfinance/login/registrationform.dart';
import 'package:stackfinance/login/loginform.dart';
import 'package:stackfinance/login/logincontroller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginControllers  loginControllers= new LoginControllers();
  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(

          width:screenWidth*0.8,



          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,


            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/noteslogin.png'),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap:()async=>loginControllers.googleAuthentication(context),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 4,

                    child: Container(

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Expanded(
                            child: Center(child: Image.asset('assets/google-symbol.png')),
                          ),
                          Expanded(child: Center(child: Text("Sign in with google")),flex: 4,),


                        ],
                      ),


                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()=>loginControllers.googleAuthentication(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 4,

                    child: Container(

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Expanded(
                            child: InkWell(
                              onTap: ()=>_modalBottomSheetLogin(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text("Login")),
                              ),
                            ),
                          ),
                          Expanded(child: InkWell(
                            onTap: ()=>_modalBottomSheetRegistration(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text("Register")),
                            ),
                          )),


                        ],
                      ),


                    ),
                  ),
                ),
              )

              ]
            ,),
        ),
      ),

    );
  }
void _modalBottomSheetLogin() {
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
            child:LoginForm() ,
            ));
      });
}

void _modalBottomSheetRegistration() {
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
                child:Registration() ,
              ));
        });
  }






}
