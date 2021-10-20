import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:intl/intl.dart';

class HelperMethods {
  final FirebaseService firebaseService = FirebaseService();
  String generateRandomDocumentId(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(rgen.nextInt(chars.length))));

  String generateRandomOrderId(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => numbers.codeUnitAt(rgen.nextInt(numbers.length))));

  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password.isEmpty) {
      return false;
    }
    var hasUppercase = password.contains(RegExp(r'[A-Z]'));
    var hasDigits = password.contains(RegExp(r'[0-9]'));
    var hasLowercase = password.contains(RegExp(r'[a-z]'));
    var hasSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    var hasMinLength = password.length >= minLength;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  String convertEpochToDate(int epoch) {
    var date = DateTime.fromMillisecondsSinceEpoch(epoch);
    final formatter = DateFormat('dd-MM-yyyy');
    final formatted = formatter.format(date);
    return formatted;
  }
}
