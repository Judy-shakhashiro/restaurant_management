// import 'package:flutter/material.dart';
// import 'package:flutter_application_restaurant/controller/profile_controller.dart';
// import 'package:flutter_application_restaurant/core/static/routes.dart';
// import 'package:flutter_application_restaurant/view/profile/Textformlogin.dart';
// import 'package:flutter_application_restaurant/view/widgets/button.dart';
// import 'package:get/get.dart';
// import 'dart:io';


// // ////////////////////////بدي ياها
// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({Key? key}) : super(key: key);

//   final ProfileController controller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.errorMessage.isNotEmpty) {
//           return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Please try again.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 18, color: Colors.red)
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                    onPressed: () {
//                       controller.fetchProfileData();
//                         }, // Retry fetch
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrange,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text('Retry'),
                  
//                 ),
//                     ],
//                   ),
//                 );
//         }

//         final profile = controller.profileInfo.value;
//         if (profile == null) {
//           return const Center(child: Text('لا توجد بيانات للعرض'));
//         }

//        String? fullImageUrl = profile.image != null ? '${Linkapi.bacUrlImage}${profile.image}' : null;

//         return Stack(
//           children: [
//             Container(
//               height: 160,
//               decoration:const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.white70,
//                     Colors.deepOrange,
//                  //   Colors.black54,
//                   ],
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(80),
//                   bottomRight: Radius.circular(80),
//                 ),
//               ),
//              // child: BackgroundAnimation(),
//             ),
//         Positioned(
//               top: 20,
//               left: 20,
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.black45,
//                   size: 30,
//                 ),
//                 onPressed: () => Get.back(),
//               ),
//             ),
//             SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 70),


//                   Center(
//                     child: Container(
//                       margin: const EdgeInsets.only(top: 20),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 20,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 130,
//                             height: 130,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Colors.black54,
//                                 width:2,
//                               ),
//                             ),
//                           ),
//                          Container(
//   width: 120,
//   height: 120,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     color: Colors.grey[200],
//   ),
//   child: ClipOval(
//     child: fullImageUrl != null
//         ? Image.network(
//             fullImageUrl,
//             fit: BoxFit.cover,
//             errorBuilder: (context, error, stackTrace) => Icon(
//               Icons.person,
//               size: 60,
//               color: Colors.grey[600],
//             ),
//           )
//         : Icon(
//             Icons.person,
//             size: 60,
//             color: Colors.grey[600],
//           ),
//   ),
// ),
//                           Positioned(
//                             bottom: 10,
//                             right: 5,
//                             child: GestureDetector(
//                               onTap: () => controller.pickAndUploadImage(),
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.black54,
//                                 ),
//                                 child: const Icon(
//                                   Icons.camera_alt,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

// const SizedBox(height: 15),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       profile.email,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontFamily: 'Georgia',
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepOrange,
//                       ),
//                     ),
//                   ),
//             const SizedBox(height: 10),

//                   Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child:  Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           TextFormProfile(
//                             mycontoller: controller.firstNameController,
//                             text: ' First_Name',
//                             iconData: Icons.person_outline,
//                             isNumber: false,
//                             isEditing: controller.isEditingGlobal.value,
//                           ),
//                           const SizedBox(height: 30),
//                           TextFormProfile(
//                             mycontoller: controller.lastNameController,
//                             text: 'Last_Name ',
//                             iconData: Icons.person_outline,
//                             isNumber: false,
//                             isEditing: controller.isEditingGlobal.value,
//                           ),
//                           const SizedBox(height: 30),
//                           TextFormProfile(
//                             mycontoller: controller.mobileController,
//                             text: ' Mobile',
//                             iconData: Icons.phone_iphone,
//                             isNumber: true,
//                             isEditing: controller.isEditingGlobal.value,
//                           ),
//                           const SizedBox(height: 30),
//                           TextFormProfile(
//                             mycontoller: controller.birthdateController,
//                             text: 'Birth_Date',
//                             iconData: Icons.cake_outlined,
//                             isNumber: false,
//                             isEditing: controller.isEditingGlobal.value,
//                             isDateField: true,
//                           ),
//                         ],
//                       )
        
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
      

//      floatingActionButton: Obx(
//   () {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300),
//       child: Button(
//         key: ValueKey<bool>(controller.isEditingGlobal.value),
//         label: controller.isEditingGlobal.value ? 'Save' : 'Edit',
//         icon: controller.isEditingGlobal.value ? Icons.save : Icons.edit,
//         onPressed: () async {
//           if (controller.isEditingGlobal.value) {
//             await controller.updateProfileData(
//               firstName: controller.firstNameController.text,
//               lastName: controller.lastNameController.text,
//               mobile: controller.mobileController.text.isNotEmpty
//                   ? controller.mobileController.text
//                   : null,
//               birthdate: controller.birthdateController.text.isNotEmpty
//                   ? controller.birthdateController.text
//                   : null,
//             );
//             controller.isEditingGlobal.value = false;
//           } else {
//             controller.firstNameController.text =
//                 controller.profileInfo.value?.firstName ?? '';
//             controller.lastNameController.text =
//                 controller.profileInfo.value?.lastName ?? '';
//             controller.mobileController.text =
//                 controller.profileInfo.value?.mobile ?? '';
//             controller.birthdateController.text =
//                 controller.profileInfo.value?.birthdate ?? '';
//             controller.isEditingGlobal.toggle();
//           }
//         },
//         elevation: 8,
//         borderRadius: BorderRadius.circular(50),
//       ).build(),
//     );
//   },
// ),


//     );
//   }
// }
  
