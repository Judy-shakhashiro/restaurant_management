import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/profile_controller.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:flutter_application_restaurant/view/auth/widget/auth/login/textform_login.dart';
import 'package:get/get.dart';
import 'package:animated_background/animated_background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 30,
            spawnMinSpeed: 15,
            particleCount: 15,
            spawnMaxSpeed: 20,
            spawnOpacity: 0.5,
            baseColor: Colors.grey,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  const Text(
                    'Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final profile = controller.profile.value;
          final String? fullImageUrl = profile?.image != null
              ? "${Linkapi.bacUrlImage}${profile?.image}"
              : null;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: fullImageUrl != null
                            ? Image.network(
                                fullImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[600],
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => controller.pickAndUploadImage(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepOrange,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  profile!.email,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Divider(thickness: 2, color: Colors.deepOrange),
                ),
                const SizedBox(height: 40),
                Textformlogin(
                  mycontoller: controller.firstNameController,
                  text: 'First Name',
                  isNumber: false,
                  iconData: Icons.person_3_rounded,
                ),
                const SizedBox(height: 30),
                Textformlogin(
                  mycontoller: controller.lastNameController,
                  text: 'Last Name',
                  isNumber: false,
                  iconData: Icons.person_3_outlined,
                ),
                const SizedBox(height: 30),
                Textformlogin(
                  mycontoller: controller.mobileController,
                  text: 'Mobile',
                  isNumber: true,
                  iconData: Icons.phone_enabled_outlined,
                ),
                const SizedBox(height: 30),
                Textformlogin(
                  mycontoller: controller.birthdateController,
                  readOnly: true,
                  text: 'Birth Date',
                  isNumber: false,
                  onTap: () => controller.pickDate(context),
                  iconData: Icons.cake_sharp,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    await controller.updateProfile();
                  },
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}