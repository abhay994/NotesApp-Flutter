import 'package:stackfinance/exports.dart';
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final LoginControllers  loginControllers= new LoginControllers();

  @override
  Widget build(BuildContext context) {
    return Stack(
     children: [
       Form(
         key: loginControllers.formKey,
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             InkWell(
               onTap: ()=>Navigator.pop(context),
               child: Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 8),
                     child: Icon(Icons.cancel),
                   ),
                 ],
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 5,bottom: 5),
               child: TextFormField(
                 style: TextStyle(fontSize: 10),
                 controller: loginControllers.emailController,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(),

                   labelText: 'Email',
//              hintText: ' ex:- 4600',


                 ),
                 keyboardType: TextInputType.text,

                 onChanged: (value){

                 },


                validator: loginControllers.validateEmail,


               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 5,bottom: 5),
               child: TextFormField(
                 style: TextStyle(fontSize: 10),
                 obscureText: true,
                 obscuringCharacter: "*",
                 controller: loginControllers.passwordController,

                 decoration: InputDecoration(
                   border: OutlineInputBorder(),
                   labelText: 'Password',



                 ),
                 keyboardType: TextInputType.text,
                 validator: loginControllers.validatePassword,


                 onChanged: (value){

                 },


               ),
             ),

             Padding(
               padding: const EdgeInsets.all(10.0),
               child: ElevatedButton(

                 style: ElevatedButton.styleFrom(primary: Colors.black),
                 onPressed: (){
                    loginControllers.loginSubmit(context);


                 }, child: Text("Login"),

               ),
             )



           ],),
       )

     ],
    );
  }

}
