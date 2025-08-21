
class Linkapi{
static bool useMockApi = false;
static const String backUrl = 'http://10.228.236.12:8000/api';

  static const String LoginApi ='$backUrl/login';
  static const String ForgetPasswordApi='$backUrl/passwords/email';
  static const String verificationApi='$backUrl/passwords/verify';
  static const String ResetPasswordApi ='$backUrl/passwords/reset';
  static const String RegisterApi = "$backUrl/register";
  static const String ConfirmEamilApi ='$backUrl/confirmation/verify';
  static const String saveNotes='$backUrl/reservations/confirm-temp-revs';
  static const String timeSlots='$backUrl/reservations/available-time-slots';
  static const String availableDates='$backUrl/reservations/available-days';
  static const String confirmReservation='$backUrl/reservations/temp-revs'; 

}