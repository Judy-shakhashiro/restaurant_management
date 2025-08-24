// import 'package:flutter/material.dart';

// class TextFormProfile extends StatelessWidget {
//   final TextEditingController mycontoller;
//   final String? text;
//   final IconData iconData;
//   final bool isNumber;
//   final bool? obscureText;
//   final String? Function(String?)? validator;
//   final VoidCallback? onTapIcon;
//   final bool isEditing;
//   final bool isDateField; 

//   const TextFormProfile({
//     super.key,
//     required this.mycontoller,
//     required this.text,
//     required this.iconData,
//     required this.isNumber,
//     this.obscureText,
//     this.validator,
//     this.onTapIcon,
//     this.isEditing = false,
//     this.isDateField = false, 
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Card(
//         color: Colors.white60,
//         elevation: 8,
        
//         child: TextFormField(
//           enabled: isEditing,
//           readOnly: isDateField,
//           controller: mycontoller,
//           validator: validator,
//           keyboardType: isNumber
//               ? const TextInputType.numberWithOptions(decimal: true)
//               : TextInputType.text,
//           obscureText: obscureText == true,
//           onTap: isDateField && isEditing
//               ? () async {
//                   final pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                     builder: (context, child) {
//                       return Theme(
//                         data: Theme.of(context).copyWith(
//                           colorScheme:const ColorScheme.light(
//                             primary: Colors.deepOrange, 
//                             onPrimary: Colors.white,
//                             onSurface: Colors.black,
//                           ),
//                           dialogBackgroundColor: Colors.white,
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
        
//                   if (pickedDate != null) {
//                     mycontoller.text =
//                         "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
//                   }
//                 }
//               : null,
//           decoration: InputDecoration(
//             hintText: text,
//             hintStyle: const TextStyle(fontSize: 15),
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//             label: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
//               child: Text(
//                 text!,
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Georgia',
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             suffixIcon: Icon(iconData, color: Colors.black),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide: const BorderSide(
//                 color: Colors.black45,
//                 width: 2,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//               borderSide: BorderSide(
//                 color: Colors.deepOrange,
//                 width: 2.0,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
