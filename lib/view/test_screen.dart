import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/widgets/profile/appbar_profile.dart';
import 'package:flutter_application_restaurant/view/widgets/profile/button_log_out.dart';
import 'package:flutter_application_restaurant/view/widgets/profile/card_account.dart';
import 'package:flutter_application_restaurant/view/widgets/profile/image_name_profile.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appbar_profile()),
        body: Container(
          child: ListView(
            children: [
              image_profile(),
              name_email_profile("ZAIN RHMON", "zynrhmwn74@gmail.com"),

              Container(margin: EdgeInsets.only(top: 23), child: Divider()),

              title_card("Account"),

              cardAccount(15, 10, 10, "Personal Data", Icon(Icons.person), 160),
              cardAccount(15, 10, 10, "Setting", Icon(Icons.settings), 205),
              cardAccount(15, 10, 10, "Order History", Icon(Icons.history), 164),

              title_card("General"),

              cardAccount(15, 10, 10, "Help Center", Icon(Icons.help), 173),
              cardAccount(15, 10, 10, "Request Account Deletion", Icon(Icons.delete_forever), 82),
              cardAccount(15, 10, 10, "Add Another Account", Icon(Icons.person_add_alt_outlined), 110),


              botton_log_out(() {}),


              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}