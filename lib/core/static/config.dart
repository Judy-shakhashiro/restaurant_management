
class Linkapi{
static bool useMockApi = false;
static const String backUrl = 'http://192.168.1.106:8000/api';
static String token='1|pD8S7CNps0H5e32wQJR7HGbV7ddr5H9a80nbskIUc7f9be35';

static const String LoginApi ='$backUrl/login';
  static const String ForgetPasswordApi='$backUrl/passwords/email';
  static const String verificationApi='$backUrl/passwords/verify';
  static const String ResetPasswordApi ='$backUrl/passwords/reset';

  /////Register
  static const String RegisterApi = "$backUrl/register";
  static const String ConfirmEamilApi ='$backUrl/confirmation/verify';

  /////reservation
  static const String saveNotes='$backUrl/reservations/confirm-temp-revs';
  static const String timeSlots='$backUrl/reservations/available-time-slots';
  static const String availableDates='$backUrl/reservations/available-days';
  static const String confirmReservation='$backUrl/reservations/temp-revs'; 

}