import 'package:duo/model/callback.dart';
import 'package:duo/constant/duo_error.dart';

class CommonUtil {
  static Callback makeSuccessCallback() {
    return new Callback(DuoError.DUO_OK, 'ok');
  }

  static Callback makeErrorCallback(int errorCode, String msg) {
    return new Callback(errorCode, msg);
  }
}
