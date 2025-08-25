import '../../controller/auth/register_controller.dart';
import '../../controller/auth/reset_controller.dart';
import 'package:get/get.dart';

RegisterControllerImp cont =Get.put(RegisterControllerImp());

String? validInput(String val, int min, int max, String type) {
  if (type == "username") {
    if (!GetUtils.isUsername(val)) {
      return "not valid username";
    }
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) {
      return "not valid email";
    }
  }

  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val) && val.length != 10) { 
      return "not valid phone";
    }
  }
  if (type == "password") {
    String? passwordError = _passwordValidator(val); 
    if (passwordError != null) {
      return passwordError;
    }
  }
  if (type == "password1") {
    String? passwordError = _confirmPasswordValidator(val); 
    if (passwordError != null) {
      return passwordError;
    }
  }

  if (val.isEmpty) {
    return "can't be Empty";
  }

  if (val.length < min) {
    return "can't be less than $min ";
  }

  if (val.length > max) {
    return "can't be larger than $max ";
  }

  return null; 
}


String? _passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password.';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long.';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter.';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter.';
  }
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character.';
  }

  return null; 
}


String? _confirmPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password.';
  }
  if (value != cont.password.text) { 
    return 'Passwords do not match.';
  }
  return null;
}


