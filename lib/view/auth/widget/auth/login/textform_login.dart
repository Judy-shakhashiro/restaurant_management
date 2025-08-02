import 'package:flutter/material.dart';

class Textformlogin extends StatelessWidget {

  Textformlogin({super.key,  this.text,  this.iconData, this.hintText, this.obscureText, this.onTapIcon, required this.isNumber, required this.mycontoller, this.validator});
  final String? hintText;
  final String? text;
  final IconData? iconData;
  final bool? obscureText;
  final TextEditingController? mycontoller;
  final void Function()? onTapIcon;
  final String? Function(String?)? validator;
  final bool isNumber;
  final  GlobalKey<FormState> formState =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 30),
      child: 
      TextFormField(
       validator: validator,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        obscureText: obscureText == null || obscureText == false ? false : true,
        controller: mycontoller,
       decoration: InputDecoration(
       hintText: hintText,
        hintStyle: const TextStyle(fontSize: 15),
         floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
         label: Container(
         margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 100),
         child: Text(
         text!,
          style: const TextStyle(
           fontSize: 23,
           fontWeight: FontWeight.bold,
           fontFamily: 'Georgia',
          color: Colors.black,
             ),)),
          suffixIcon:InkWell(
          onTap:onTapIcon ,
          child: Icon(iconData,color:  Colors.orange.shade900) ,
                    ),
          border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(5), //borderSide: BorderSide.none,
          ),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5), 
        borderSide:const BorderSide( 
        color: Colors.black45,
        width: 2, ), ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide( 
        color:  Colors.orange[900]!,
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