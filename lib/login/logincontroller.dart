import 'package:stackfinance/exports.dart';



class LoginControllers{

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmPasswordController = new TextEditingController();

  LoginControllers();

  String validateEmail(String value) {
    Pattern pattern =r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9]$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim()))
      return 'Enter Valid Email';
    else
      return null;
  }



  String validateConfirmPassword(String value) {

    if (passwordController.text!=value)
      return "Password Doesn't Match";
    else
      return null;
  }




  String validatePassword(String value) {

    if (value.length<6)
      return "Password should be greater than 6 charaters";
    else
      return null;
  }



  registrationSubmit(BuildContext context) async{
    if (formKey.currentState.validate()) {

    await  services.createUser(email: emailController.text.trim(),password: passwordController.text.trim())
          .then((userCredential) {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Successfully Registered"),));

        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pop(context);
        });


      }).catchError((e){
        switch (e.code) {
          case 'weak-password':
            {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Weak Password"),));
            }

            break;

          case 'email-already-in-use':
            {
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Email already exists!"),));
            }
            break;
          default:{

              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e),));
          }



        }

      });



    }
  }




  loginSubmit(BuildContext context) async{
    if (formKey.currentState.validate()) {

    await  services.loginUser(email: emailController.text.trim(),password: passwordController.text.trim())
          .then((userCredential) async{


            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Loading...")));

        services.firebaseInsertUserDetail(userCredential: userCredential,loginType: services.checkAuthtype(loginType.EmailAndPasswordAuthentication));

        await  services.dataSignInBackup();

        await  services.getNotes();



        Future.delayed(Duration(milliseconds: 500),(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => NotesDashboard()));
        });



      }).catchError((e){
        print(e.code);
        switch (e.code) {
          case 'user-not-found':{

            Future.delayed(Duration(milliseconds: 100),(){

              Navigator.pop(context);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(child: Text("Email Does'nt Exists")),));



          }



            break;

          case 'wrong-password':{
            Future.delayed(Duration(milliseconds: 100),(){

              Navigator.pop(context);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Wrong Password"),));
          }


            break;
          default:{
            Future.delayed(Duration(milliseconds: 100),(){

              Navigator.pop(context);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e),));
          }

        }

      });



    }
  }




  googleAuthentication(BuildContext context) async{


     await services.signInWithGoogle()
          .then((userCredential)async {




        services.firebaseInsertUserDetail(userCredential: userCredential,loginType: services.checkAuthtype(loginType.googleAuthentication));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Loading..."),));


        await  services.dataSignInBackup();

        await  services.getNotes();


        Future.delayed(Duration(milliseconds: 500),(){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => NotesDashboard()));
        });



      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e),));

      });




  }





}