import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Textformlogin extends StatelessWidget {

  Textformlogin({super.key,this.isDateField=false ,this.onTap ,this.text,  this.iconData,this.readOnly, this.hintText, this.obscureText, this.onTapIcon, required this.isNumber, required this.mycontoller, this.validator});
  final String? hintText;
  final bool? readOnly;
  final String? text;
  final IconData? iconData;
  final bool? obscureText;
  final TextEditingController? mycontoller;
  final void Function()? onTapIcon;
  final String? Function(String?)? validator;
  final bool isNumber;
   void Function()? onTap;
   final bool isDateField;
  final  GlobalKey<FormState> formState =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProfileController controller1 = Get.put(ProfileController());
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 30),
      child: 
      TextFormField(
        readOnly: readOnly ?? false,
       validator: validator,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        obscureText: obscureText == null || obscureText == false ? false : true,
        onTap:onTap,
        controller: mycontoller,
       decoration: InputDecoration(
       hintText: hintText,
       
      //  hintStyle: const TextStyle(fontSize: 15),
         floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
         label: Container(
         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
         child: Text(
         text!,
          style: const TextStyle(
           fontSize: 24,
           fontWeight: FontWeight.bold,
           fontFamily: 'Georgia',
          color: Colors.black,
             ),)),
          suffixIcon:InkWell(
          child: Icon(iconData,color:  Colors.black,size: 22,) ,
                    ),
          border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(5), //borderSide: BorderSide.none,
          ),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5), 
        borderSide:const BorderSide( 
        color: Colors.black38,
        width: 2, ), ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide:const BorderSide( 
        color:  Colors.black,
        width: 2.0, ), ),
                                    ),
    ));
  }
}   


// TextFormField(
//   validator: validator,
//   keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
//   obscureText: obscureText == null || obscureText == false ? false : true,
//   controller: mycontoller,
//   decoration: InputDecoration(
//     hintText: hintText,
//     hintStyle: const TextStyle(fontSize: 15),
//     floatingLabelBehavior: FloatingLabelBehavior.always,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//     label: Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
//       child: Text(
//         text!,
//         style: const TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     ),
//     suffixIcon: InkWell(
//       onTap: onTapIcon,
//       child: Icon(iconData, color: Colors.black),
//     ),
//     // قم بتغيير هذا الجزء:
//     border: const UnderlineInputBorder( // تغيير إلى UnderlineInputBorder
//       borderSide: BorderSide(color: Colors.black, width: 2), // يمكنك تحديد لون وعرض الخط الافتراضي
//     ),
//     enabledBorder: const UnderlineInputBorder( // تغيير إلى UnderlineInputBorder
//       borderSide: BorderSide(
//         color: Colors.black45,
//         width: 2,
//       ),
//     ),
//     focusedBorder: const UnderlineInputBorder( // تغيير إلى UnderlineInputBorder
//       borderSide: BorderSide(
//         color: Color.fromARGB(255, 223, 201, 1), // تأكد من صحة هذا اللون
//         width: 2.0,
//       ),
//     ),
//     // يمكنك أيضاً إضافة prefixIcon إذا كنت تريده يظهر على الخط
//     // prefixIcon: Icon(Icons.email, color: Colors.grey),
//   ),
// );